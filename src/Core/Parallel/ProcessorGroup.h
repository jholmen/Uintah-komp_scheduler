/*
 * The MIT License
 *
 * Copyright (c) 1997-2018 The University of Utah
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to
 * deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 */

#ifndef CORE_PARALLEL_PROCESSORGROUP_H
#define CORE_PARALLEL_PROCESSORGROUP_H

#include <Core/Parallel/UintahMPI.h>

#include <string>
#include <vector>

namespace Uintah {

/**************************************

 CLASS
 ProcessorGroup


 GENERAL INFORMATION

 ProcessorGroup.h

 Steven G. Parker
 Department of Computer Science
 University of Utah

 Center for the Simulation of Accidental Fires and Explosions (C-SAFE)


 KEYWORDS
 Processor_Group


 DESCRIPTION


 WARNING

 ****************************************/

class Parallel;

class ProcessorGroup {

public:

  ~ProcessorGroup();

  std::string myProcName() const { return std::string(m_proc_name); }

  // Returns the total number of nodes this MPI session is running on.
  int nNodes() const { return m_nNodes; }
  int myNode() const { return m_node; }

  int myNode_nRanks() const { return m_node_nRanks; }
  int myNode_myRank() const { return m_node_rank; }
  
  // Returns the total number of MPI ranks in this MPI session.
  int nRanks() const { return m_nRanks; }
  int myRank() const { return m_rank; }

  MPI_Comm getComm() const { return m_comm; }
  MPI_Comm getNodeComm() const { return m_node_comm; }

  MPI_Comm getGlobalComm( int comm_idx ) const
  {
    if (comm_idx == -1 || m_threads <= 1) {
      return m_comm;
    } else {
      return m_global_comms[comm_idx];
    }
  }

  void setGlobalComm( int num_comms ) const;


private:

  // can only be called from Parallel
  ProcessorGroup( const ProcessorGroup * parent
                ,       MPI_Comm         comm
                ,       int              rank
                ,       int              size
                ,       int              threads
                );

  // eliminate copy, assignment and move
  ProcessorGroup( const ProcessorGroup & )            = delete;
  ProcessorGroup& operator=( const ProcessorGroup & ) = delete;
  ProcessorGroup( ProcessorGroup && )                 = delete;
  ProcessorGroup& operator=( ProcessorGroup && )      = delete;

  char m_proc_name[MPI_MAX_PROCESSOR_NAME];
  
  int  m_node;   // Node this rank is executing on.
  int  m_nNodes; // Total number of nodes this MPI session is running on.

  int  m_node_rank;   // MPI rank of this process relative to the node.
  int  m_node_nRanks; // Total number of MPI Ranks relative to the node.

  int  m_rank;   // MPI rank of this process.
  int  m_nRanks; // Total number of MPI Ranks.

  int  m_threads;

  MPI_Comm                        m_comm;
  MPI_Comm                        m_node_comm;
  mutable std::vector<MPI_Comm>   m_global_comms;
  const ProcessorGroup          * m_parent_group;

  friend class Parallel;
};

}  // namespace Uintah

#endif // end CORE_PARALLEL_PROCESSORGROUP_H
