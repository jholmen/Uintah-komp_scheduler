/*
   For more information, please see: http://software.sci.utah.edu

   The MIT License

   Copyright (c) 2004 Scientific Computing and Imaging Institute,
   University of Utah.

   License for the specific language governing rights and limitations under
   Permission is hereby granted, free of charge, to any person obtaining a
   copy of this software and associated documentation files (the "Software"),
   to deal in the Software without restriction, including without limitation
   the rights to use, copy, modify, merge, publish, distribute, sublicense,
   and/or sell copies of the Software, and to permit persons to whom the
   Software is furnished to do so, subject to the following conditions:

   The above copyright notice and this permission notice shall be included
   in all copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
   OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
   THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
   FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
   DEALINGS IN THE SOFTWARE.
*/



/*
 *  Timer.h: Interface to portable timer utility classes
 *
 *  Written by:
 *   Steven G. Parker
 *   Department of Computer Science
 *   University of Utah
 *   Feb. 1994
 *
 *  Copyright (C) 1994 SCI Group
 */

#ifndef SCI_Containers_Timer_h
#define SCI_Containers_Timer_h 1

#include <Core/share/share.h>

class SCICORESHARE Timer {
    double total_time;
    double start_time;
    enum State {
	Stopped,
	Running
    };
    State state;
    virtual double get_time()=0;
public:
    Timer();
    virtual ~Timer();
    void start();
    void stop();
    void clear();
    double time();
    void add(double t);
};

class SCICORESHARE CPUTimer : public Timer {
    virtual double get_time();
public:
    virtual ~CPUTimer();
};

class SCICORESHARE WallClockTimer : public Timer {
    virtual double get_time();
public:
    WallClockTimer();
    virtual ~WallClockTimer();
};

class SCICORESHARE TimeThrottle : public WallClockTimer {
public:
    TimeThrottle();
    virtual ~TimeThrottle();
    void wait_for_time(double time);
};

#endif /* SCI_Containers_Timer_h */
