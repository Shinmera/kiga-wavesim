#|
 This file is a part of Wavesim
 (c) 2014 TymoonNET/NexT http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(defpackage wavesim
  (:nicknames #:org.tymoonnext.kiga.wavesim)
  (:use #:cl)
  ;; simulator.lisp
  (:export
   #:wave-environment
   #:current
   #:advance
   #:start-wave)
  ;; main.lisp
  (:export
   #:*thread*
   #:*window-size*
   #:*granularity*
   #:*spacing*
   #:start
   #:start-threaded))
