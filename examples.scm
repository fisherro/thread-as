(import (scheme base)
	(scheme write)
	(srfi 1)
	(srfi 26)
	(srfi 130)
	(fisherro seq)
	(fisherro pipe))

(define (compose . fs)
  (if (null? fs)
    values
    (lambda args
      ((car fs)
       (apply (apply compose (cdr fs))
	      args)))))

(define (rcompose . fs)
  (apply compose (reverse fs)))

(display
  (string-join 
    (map
      (cute string-pad <> 2)
      (map
	number->string
	(map
	  (cute * <> 2)
	  (iota 10))))
    ", "))
(newline)

((compose display
	  (cute string-join <> ", ")
	  (cute map (cute string-pad <> 2) <>)
	  (cute map number->string <>)
	  (cute map (cute * <> 2) <>)
	  iota)
 10)
(newline)

((rcompose iota
	   (cute map (cute * <> 2) <>)
	   (cute map number->string <>)
	   (cute map (cute string-pad <> 2) <>)
	   (cute string-join <> ", ")
	   display)
 10)
(newline)

;((rcompose (cute iota 10)
;	   (cute map (cute * <> 2) <>)
;	   (cute map number->string <>)
;	   (cute map (cute string-pad <> 2) <>)
;	   (cute string-join <> ", ")
;	   display))
;(newline)

((rcompose iota
	   (cute map (cute * <> 2) <>)
	   (cute map number->string <>)
	   (lambda (it)
	     (map (cute string-pad
			<>
			(apply max (map string-length it)))
		  it))
	   (cute string-join <> ", ")
	   display)
 10)
(newline)

(let* ((it (iota 10))
       (it (map (cute * <> 2) it))
       (it (map number->string it))
       (it (map (cute string-pad <> 2) it))
       (it (string-join it ", ")))
  (display it))
(newline)

(let* ((it (iota 10))
       (it (map (cute * <> 2) it))
       (it (map number->string it))
       (it (map (cute string-pad <> (apply max (map string-length it))) it))
       (it (string-join it ", ")))
  (display it))
(newline)

(let*
  ((numbers (iota 10))
   (doubles (map (cute * <> 2) numbers))
   (strings (map number->string doubles))
   (padded  (map
	      (cute string-pad <> (apply max (map string-length strings)))
	      strings))
   (the-string (string-join padded ", ")))
  (display the-string))
(newline)

(seq (iota 10)
     (map (cute * <> 2) it)
     (map number->string it)
     (map (cute string-pad <> (apply max (map string-length it))) it)
     (string-join it ", ")
     (display it))
(newline)

(pipe it
      (iota 10)
      (map (cute * <> 2) it)
      (map number->string it)
      (map (cute string-pad <> (apply max (map string-length it))) it)
      (string-join it ", ")
      (display it))
(newline)

(pipe this
      (iota 10)
      (map (cute * <> 2) this)
      (map number->string this)
      (pipe that
	    (map string-length this)
	    (apply max that)
	    (map (cute string-pad <> that)
		 this))
      (string-join this ", "))
(newline)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(pipe _
      "hello😀"
      (string->list _)
      (map char->integer _)
      (map (cute number->string <> 16) _)
      (map (lambda (x)
	     (if (> 4 (string-length x))
	       (string-pad x 4 #\0)
	       x))
	   _)
      (map (cute string-append "U+" <>) _)
      (string-join _ " ")
      (display _)
      (newline))

