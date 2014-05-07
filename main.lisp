#|
 This file is a part of Wavesim
 (c) 2014 TymoonNET/NexT http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(in-package #:org.tymoonnext.kiga.wavesim)

(defvar *thread* NIL)
(defvar *env*)
(defparameter *window-size* 500)
(defparameter *granularity* 7)
(defparameter *spacing* 5)

(defun process ()
  (advance *env*))

(defun draw ()
  ;; Optimization possibility: Combine process and draw
  ;; so iteration only has to occur once. Makes code ugly
  ;; though, so I'll leave it for now.
  (sdl:clear-display (sdl:color))
  (dotimes (y (array-dimension (current *env*) 0))
    (dotimes (x (array-dimension (current *env*) 0))
      (sdl:draw-box-* (floor (+ (* *granularity* x) (/ *spacing* 2)))
                      (floor (+ (* *granularity* y) (/ *spacing* 2)))
                      (- *granularity* *spacing*) (- *granularity* *spacing*)
                      :color (let ((val (aref (current *env*) y x)))
                               (if (< val 0)
                                   (sdl:color :r 10 :g 10 :b (max 0 (min 255 (- val))))
                                   (sdl:color :r (max 0 (min 255 val)) :g 10 :b 10)))))))

(defun start ()
  (setf *env* (make-instance 'wave-environment :width (floor (/ *window-size* *granularity*))
                                               :height (floor (/ *window-size* *granularity*))))
  (sdl:with-init ()
    (sdl:window *window-size* *window-size* :title-caption "Kiga Wavesim")
    (sdl:update-display)
    (sdl:with-events ()
      (:quit-event () T)
      (:mouse-button-up-event (:x x :y y)
        (format T "CLICK: ~d/~d~%" x y)
        (start-wave *env*
                    (1+ (floor (/ x *granularity*)))
                    (1+ (floor (/ y *granularity*)))
                    1000.0))
      (:idle ()
        (process)
        (draw)
        (sdl:update-display)))))

(defun start-threaded ()
  (setf *thread*
        (bordeaux-threads:make-thread #'start :initial-bindings `((*standard-output* . ,*standard-output*)))))
