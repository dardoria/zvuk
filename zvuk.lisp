;;;; clmsndlib.lisp
(in-package #:zvuk)

(defun play-file (filename)
  (let ((fd (mus-sound-open-input filename)))
    (unless (= fd -1)
      (let* ((chans (mus-sound-chans filename))
	     (srate (mus-sound-srate filename))
	     (frames (mus-sound-frames filename))
	     (outbytes (* *buffer-size* chans 2))
	     (bufs (foreign-alloc :pointer :count chans))
	     (obuf (foreign-alloc :short :count (* *buffer-size* chans)))
	     (afd 0))
	(loop for i from 0 below chans
	   do (setf (mem-aref bufs :pointer i) (foreign-alloc :double :count *buffer-size*)))

	(setf afd (mus-audio-open-output +mus-audio-default+ srate chans +mus-audio-compatible-format+ outbytes))

	(unless (= afd -1)
	  (loop for i from 0 below frames by *buffer-size*
	     do (mus-sound-read fd 0 (- *buffer-size* 1) chans bufs)
	     do (loop for k from 0 below *buffer-size*
		   for j from 0 by chans
		   do (loop for n from 0 below chans
			 do (setf (mem-aref obuf :short (+ j n)) 
					    (mus-sample-to-short (mem-aref (mem-aref bufs :pointer n) :double k)))))
	     do (mus-audio-write afd obuf outbytes))
	  (mus-audio-close afd)
	  (mus-sound-close-input fd)
	  (loop for i below chans
	     do (foreign-free (mem-aref bufs :pointer i)))
	  (foreign-free bufs)
	  (foreign-free obuf))))))
			   

;; int main(int argc, char *argv[])
;; {
;;   int fd, afd, i, j, n, k, chans, srate, outbytes;
;;   mus_long_t frames;
;;   mus_sample_t **bufs;
;;   short *obuf;
;;   mus_sound_initialize();	
;;   fd = mus_sound_open_input(argv[1]);
;;   if (fd != -1)
;;     {
;;       chans = mus_sound_chans(argv[1]);
;;       srate = mus_sound_srate(argv[1]);
;;       frames = mus_sound_frames(argv[1]);
;;       outbytes = BUFFER_SIZE * chans * 2;
;;       bufs = (mus_sample_t **)calloc(chans, sizeof(mus_sample_t *));
;;       for (i=0;i<chans;i++) 
;;         bufs[i] = (mus_sample_t *)calloc(BUFFER_SIZE, sizeof(mus_sample_t));
;;       obuf = (short *)calloc(BUFFER_SIZE * chans, sizeof(short));
;;       afd = mus_audio_open_output(MUS_AUDIO_DEFAULT, srate, chans, MUS_AUDIO_COMPATIBLE_FORMAT, outbytes);
;;       if (afd != -1)
;; 	{
;; 	  for (i = 0; i < frames; i += BUFFER_SIZE)
;; 	    {
;; 	      mus_sound_read(fd, 0, BUFFER_SIZE - 1, chans, bufs);
;; 	      for (k = 0, j = 0; k < BUFFER_SIZE; k++, j += chans)
;; 		for (n = 0; n < chans; n++) 
;;                   obuf[j + n] = MUS_SAMPLE_TO_SHORT(bufs[n][k]);
;; 	      mus_audio_write(afd, (char *)obuf, outbytes);
;; 	    }
;; 	  mus_audio_close(afd);
;; 	}
;;       mus_sound_close_input(fd);
;;       for (i = 0; i < chans; i++) free(bufs[i]);
;;       free(bufs);
;;       free(obuf);
;;     }