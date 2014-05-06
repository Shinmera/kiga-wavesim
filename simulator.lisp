#|
 This file is a part of Wavesim
 (c) 2014 TymoonNET/NexT http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(in-package #:org.tymoonnext.kiga.wavesim)

(defclass wave-environment ()
  ((%width :initarg :width :accessor width)
   (%height :initarg :height :accessor height)
   (%current :initarg :environment :initform NIL :accessor current)
   (%next :accessor next)
   (%previous :accessor previous))
  (:documentation ""))

(defmethod initialize-instance :after ((env wave-environment) &rest rest)
  (declare (ignore rest))
  (flet ((make-fitting-array () (make-array (list (height env) (width env)) :element-type 'single-float :initial-element 0.0)))
    (unless (current env)
      (unless (and (width env) (height env))
        (error "WIDTH and HEIGHT or ENVIRONMENT must be supplied."))
      (setf (current env) (make-fitting-array)))
    (setf (width env) (array-dimension (current env) 1)
          (height env) (array-dimension (current env) 0))
    (setf (previous env) (make-fitting-array)
          (next env) (make-fitting-array))))

(defun compute-next (x y cur pre dd dt c)
  (declare (fixnum x y) (single-float dd dt c)
           ((simple-array single-float (* *)) cur pre)
           (optimize (speed 3) (safety 0)))
  (- (* (/ (+ (aref cur y (1+ x))
              (aref cur y (1- x))
              (aref cur (1+ y) x)
              (aref cur (1- y) x)
              (* -4 (aref cur y x)))
           (expt dd 2))
        (expt c 2)
        (expt dt 2))
     (* -2 (aref cur y x))
     (aref pre y x)))

(defgeneric advance (env &key dd dt c)
  (:method ((env wave-environment) &key (dd 1.0) (dt 3.0) (c 1.0))
    (let ((next (next env))
          (current (current env))
          (previous (previous env))
          (first (previous env)))
      (loop for y from 1 below (1- (array-dimension next 0))
            do (loop for x from 1 below (1- (array-dimension next 1))
                     do (setf (aref next y x)
                              (compute-next x y current previous dt dd c))))
      (setf (next env) first
            (previous env) current
            (current env) next))))

(defgeneric start-wave (env x y magnitude)
  (:method ((env wave-environment) x y magnitude)
    (format T "WAVE: ~d/~d~%" x y)
    (setf (aref (current env) y x) magnitude)))
