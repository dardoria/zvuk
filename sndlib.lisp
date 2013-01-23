;;    Copyright 2012 Boian Tzonev <boiantz@gmail.com>

;;    Licensed under the Apache License, Version 2.0 (the "License");
;;     you may not use this file except in compliance with the License.
;;     You may obtain a copy of the License at

;;        http://www.apache.org/licenses/LICENSE-2.0

;;    Unless required by applicable law or agreed to in writing, software
;;     distributed under the License is distributed on an "AS IS" BASIS,
;;     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;;     See the License for the specific language governing permissions and
;;     limitations under the License.

(in-package #:zvuk)

(and #-darwin #+little-endian)
(defvar +mus-audio-compatible-format+ :mus-lshort)
(defvar +mus-sample-bits+ 24)

(defun mus-sound-read (fd beg end chans bufs)
  (mus-file-read fd beg end chans bufs))

(defcenum audio-types
  :mus-unsupported :mus-next :mus-aifc :mus-riff :mus-rf64 :mus-bicsf :mus-nist :mus-inrs :mus-esps :mus-svx :mus-voc 
  :mus-sndt :mus-raw :mus-smp :mus-avr :mus-ircam :mus-sd1 :mus-sppack :mus-mus10 :mus-hcom :mus-psion :mus-maud
  :mus-ieee :mus-matlab :mus-adc :mus-midi :mus-soundfont :mus-gravis :mus-comdisco :mus-goldwave :mus-srfs
  :mus-midi-sample-dump :mus-diamondware :mus-adf :mus-sbstudioii :mus-delusion
  :mus-farandole :mus-sample-dump :mus-ultratracker :mus-yamaha-sy85 :mus-yamaha-tx16w :mus-digiplayer
  :mus-covox :mus-avi :mus-omf :mus-quicktime :mus-asf :mus-yamaha-sy99 :mus-kurzweil-2000
  :mus-aiff :mus-paf :mus-csl :mus-file-samp :mus-pvf :mus-soundforge :mus-twinvq :mus-akai4
  :mus-impulsetracker :mus-korg :mus-nvf :mus-caff :mus-maui :mus-sdif :mus-ogg :mus-flac :mus-speex :mus-mpeg
  :mus-shorten :mus-tta :mus-wavpack :mus-sox
  :mus-num-header-types)

(defcenum audio-sizes 
  :mus-unknown :mus-bshort :mus-mulaw :mus-byte :mus-bfloat :mus-bint :mus-alaw :mus-ubyte :mus-b24int
  :mus-bdouble :mus-lshort :mus-lint :mus-lfloat :mus-ldouble :mus-ubshort :mus-ulshort :mus-l24int
  :mus-bintn :mus-lintn :mus-bfloat-unscaled :mus-lfloat-unscaled :mus-bdouble-unscaled :mus-ldouble-unscaled
  :mus-num-data-formats)

(defcenum error-codes 
  :mus-no-error :mus-no-frequency :mus-no-phase :mus-no-gen :mus-no-length
  :mus-no-free :mus-no-describe :mus-no-data :mus-no-scaler
  :mus-memory-allocation-failed :mus-unstable-two-pole-error
  :mus-cant-open-file :mus-no-sample-input :mus-no-sample-output
  :mus-no-such-channel :mus-no-file-name-provided :mus-no-location :mus-no-channel
  :mus-no-such-fft-window :mus-unsupported-data-format :mus-header-read-failed
  :mus-unsupported-header-type
  :mus-file-descriptors-not-initialized :mus-not-a-sound-file :mus-file-closed :mus-write-error
  :mus-header-write-failed :mus-cant-open-temp-file :mus-interrupted :mus-bad-envelope
  
  :mus-audio-channels-not-available :mus-audio-srate-not-available :mus-audio-format-not-available
  :mus-audio-no-input-available :mus-audio-configuration-not-available
  :mus-audio-write-error :mus-audio-size-not-available :mus-audio-device-not-available
  :mus-audio-cant-close :mus-audio-cant-open :mus-audio-read-error
  :mus-audio-cant-write :mus-audio-cant-read :mus-audio-no-read-permission
  
  :mus-cant-close-file :mus-arg-out-of-range :mus-wrong-type-arg
  :mus-no-channels :mus-no-hop :mus-no-width :mus-no-file-name :mus-no-ramp :mus-no-run
  :mus-no-increment :mus-no-offset
  :mus-no-xcoeff :mus-no-ycoeff :mus-no-xcoeffs :mus-no-ycoeffs :mus-no-reset :mus-bad-size :mus-cant-convert
  :mus-read-error :mus-no-safety
  :mus-initial-error-tag)


;;;;-------- sound.c --------

(defcfun ("mus_error" mus-error) :int (error :int) (format :string))
(defcfun ("mus_print" mus-print) :void (format :string))
(defcfun ("mus_format" mus-format) :pointer (format :string))
(defcfun ("mus_sndprintf" mus-sndprintf) :void (buffer :string) (buffer-len :int) (format :string))

;; typedef void mus_error_handler_t(int type, char *msg);
(defcfun ("mus_error_set_handler" mus-error-set-handler) :pointer (new-error-handler :pointer))
(defcfun ("mus_error_type_to_string" mus-error-type-to-string) :pointer (err :int))

;; typedef void mus_print_handler_t(char *msg);
(defcfun ("mus_print_set_handler" mus-print-set-handler) :pointer (new-print-handler :pointer))

;; typedef mus_sample_t mus_clip_handler_t(mus_sample_t val);
;; MUS_EXPORT mus_clip_handler_t *mus_clip_set_handler(mus_clip_handler_t *new_clip_handler);

(defcfun ("mus_sound_samples" mus-sound-samples) :ullong (arg :string))
(defcfun ("mus_sound_frames" mus-sound-frames) :ullong (arg :string))
(defcfun ("mus_sound_datum_size" mus-sound-datum-size) :int (arg :string))
(defcfun ("mus_sound_data_location" mus-sound-data-location) :ullong (arg :string))
(defcfun ("mus_sound_chans" mus-sound-chans) :int (arg :string))
(defcfun ("mus_sound_srate" mus-sound-srate) :int (arg :string))
(defcfun ("mus_sound_header_type" msu-sound-header-type) :int (arg :string))
(defcfun ("mus_sound_data_format" mus-sound-data-format) :int (arg :string))
(defcfun ("mus_sound_original_format" mus-sound-original-format) :int (arg :string))
(defcfun ("mus_sound_comment_start" mus-sound-comment-start) :ullong (arg :string))
(defcfun ("mus_sound_comment_end" mus-sound-comment-end) :ullong (arg :string))
(defcfun ("mus_sound_length" mus-sound-length) :ullong (arg :string))
(defcfun ("mus_sound_fact_samples" mus-sound-fact-samples) :int (arg :string))
(defcfun ("mus_sound_write_date" mus-sound-write-date) :double (arg :string)) ;;todo time_t
(defcfun ("mus_sound_type_specifier" mus-sound-type-specifier) :int (arg :string))
(defcfun ("mus_sound_block_align" mus-sound-block-align) :int (arg :string))
(defcfun ("mus_sound_bits_per_sample" mus-sound-bits-per-sample) :int (arg :string))

(defcfun ("mus_sound_set_chans" mus-sound-set-chans) :int (arg :string) (val :int))
(defcfun ("mus_sound_set_srate" mus-sound-set-srate)  :int (arg :string) (val :int))
(defcfun ("mus_sound_set_header_type" mus-sound-set-header-type) :int (arg :string) (val :int))
(defcfun ("mus_sound_set_data_format" mus-sound-set-data-format) :int (arg :string) (val :int))
(defcfun ("mus_sound_set_data_location" mus-sound-set-data-location) :int (arg :string) (val :double))
(defcfun ("mus_sound_set_samples" mus-sound-set-samples) :int (arg :string) (val :double))

(defcfun ("mus_header_type_name" mus-header-type-name) :string (type :int))

(defcfun ("mus_data_format_name" %mus-data-format-name) :string (format :int))
(defun mus-data-format-name (format)
  (%mus-data-format-name (foreign-enum-value 'audio-sizes format)))

(defcfun ("mus_header_type_to_string" mus-header-type-to-string) :string (type :int))

(defcfun ("mus_data_format_to_string" %mus-data-format-to-string) :string (format :int))
(defun mus-data-format-to-string (format)
  (%mus-data-format-to-string (foreign-enum-value 'audio-sizes format)))

(defcfun ("mus_data_format_short_name" %mus-data-format-short-name) :string (format :int))
(defun mus-data-format-short-name (format)
  (%mus-data-format-short-name (foreign-enum-value 'audio-sizes format)))

(defcfun ("mus_sound_comment" mus-sound-comment) :string (name :string))

(defcfun ("mus_bytes_per_sample" %mus-bytes-per-sample) :int (format :int))
(defun mus-bytes-per-sample (format)
  (%mus-bytes-per-sample (foreign-enum-value 'audio-sizes format)))

(defcfun ("mus_sound_duration" mus-sound-duration) :float (arg :string))
(defcfun ("mus_sound_initialize" mus-sound-initialize) :int)
(defcfun ("mus_sample_bits" mus-sample-bits) :int)
(defcfun ("mus_sound_override_header" mus-sound-override-header) :int (arg :string) (srate :int) (format :int) (type :int) (location :double) (size :double))
(defcfun ("mus_sound_forget" mus-sound-forget) :int (name :string))
(defcfun ("mus_sound_prune" mus-sound-prune) :int)

;todo (defcfun void mus_sound_report_cache(FILE *fp);
(defcfun ("mus_sound_loop_info" mus-sound-loop-info) :int (arg :string))
(defcfun ("mus_sound_set_loop_info" mus-sound-set-loop-info) :void (arg :string) (loop :int))
(defcfun ("mus_sound_mark_info" mus-sound-mark-info) :int (arg :string) (mark-ids :pointer) (mark-positions :pointer))

(defcfun ("mus_sound_open_input" mus-sound-open-input) :int (arg :string))
(defcfun ("mus_sound_open_output" mus-sound-output) :int (arg :string) (srate :int) (chans :int) (data-format :int) (header-type :int) (comment :string))
(defcfun ("mus_sound_reopen_output" mus-sound-reopen-output) :int (arg :string) (chans :int) (format :int) (type :int) (data-loc :double))
(defcfun ("mus_sound_close_input" mus-sound-close-input) :int (fd :int))
(defcfun ("mus_sound_close_output" mus-sound-close-output) :int (fd :int) (bytes-of-data :double))

(defcfun ("mus_sound_maxamps" mus-sound-maxamps) :ullong (ifile :string) (chans :int) (vals (:pointer :double)) (times (:pointer :double)))
(defcfun ("mus_sound_set_maxamps" mus-sound-set-maxamps) :int (ifile :string) (chans :int) (vals (:pointer :double)) (times (:pointer :double)))
(defcfun ("mus_sound_maxamp_exists" mus-sound-maxamp-exists) :boolean (ifile :string))


(defcfun ("mus_file_to_array" mus-file-to-array) :ullong (filename :string) (chan :int) (start :ullong) (samples :ullong) (array :pointer))

(defun file->array (filename chan start samples array)
  (ffa:with-pointer-to-array (array a-pointer :double (length array) :copy-out)
    (mus-file-to-array (namestring filename) chan start samples a-pointer)))

(defcfun ("mus_array_to_file" mus-array-to-file):int (filename :string) (ddata :pointer) (len :ullong) (srate :int) (channels :int))

(defun array->file (filename ddata len srate channels)
  (ffa:with-pointer-to-array (ddata a-pointer :double (length ddata) :copy-in)
    (mus-array-to-file (namestring filename) a-pointer len srate channels)))

(defcfun ("mus_array_to_file_with_error" mus-array-to-file-with-error) :string (filename :string) (ddata (:pointer :double)) (len :ullong) (srate :int) (channels :int))

(defcfun ("mus_file_to_float_array" mus-file-to-float-array) :ullong (filename :string) (chan :int) (start :ullong) (samples :ullong) (array (:pointer :double)))
(defcfun ("mus_float_array_to_file" mus-float-array-to-file) :int (filename :string) (ddata (:pointer :double)) (len :ullong) (srate :int) (channels :int))



;; -------- audio.c --------

(defcfun ("mus_audio_describe" mus-audio-describe) :string)
(defcfun ("mus_audio_open_output" %mus-audio-open-output) :int (dev :int) (srate :int) (chans :int) (format :int) (size :int))
(defun mus-audio-open-output (device srate chans format size) 
    (%mus-audio-open-output device srate chans (foreign-enum-value 'audio-sizes format) size))

(defcfun ("mus_audio_open_input" %mus-audio-open-input) :int (dev :int) (srate :int) (chans :int) (format :int) (size :int))
(defun mus-audio-open-input (device srate channels format size)
  (%mus-audio-open-input device srate channels (foreign-enum-value 'audio-sizes format) size))
  
(defcfun ("mus_audio_write" %mus-audio-write) :int (line :int) (buffer :pointer) (bytes :int))
(defun mus-audio-write (line buffer bytes)
  (ffa:with-pointer-to-array (buffer a-pointer :int16 (length buffer) :copy-in)
    (%mus-audio-write line a-pointer bytes)))

(defcfun ("mus_audio_close" mus-audio-close) :int (line :int))
(defcfun ("mus_audio_read" mus-audio-read) :int (line :int) (buffer :pointer) (bytes :int))

(defcfun ("mus_audio_write_buffers" mus-audio-write-buffers) :int (line :int) (frames :int) (chans :int) (bufs :pointer) (output-format :int) (clipped :boolean))
(defcfun ("mus_audio_read_buffers" mus-audio-read-buffers) :int (line :int) (frames :int) (chans :int) (bufs :pointer) (output-format :int) (clipped :boolean))
(defcfun ("mus_audio_initialize" mus-audio-initialize) :int)
(defcfun ("mus_audio_reinitialize" mus-audio-reinitialize) :int)
(defcfun ("mus_audio_systems" mus-audio-systems) :int)
(defcfun ("mus_audio_moniker" mus-audio-moniker) :string)
(defcfun ("mus_audio_api" mus-audio-api) :int)
(defcfun ("mus_audio_compatible_format" mus-audio-compatible-format) :int)

(defcfun ("mus_oss_set_buffers" mus-oss-set-buffers) :void (nume :int) (size :int))

(defcfun ("mus_alsa_playback_device" mus-alsa-playback-device) :string)
(defcfun ("mus_alsa_set_playback_device" mus-alsa-set-playback-device) :string (name :string))
(defcfun ("mus_alsa_capture_device" mus-alsa-capture-device) :string)
(defcfun ("mus_alsa_set_capture_device" mus-alsa-set-capture-device) :string (name :string))
(defcfun ("mus_alsa_device" mus-alsa-device) :string)
(defcfun ("mus_alsa_set_device" mus-alsa-set-device) :string (name :string))
(defcfun ("mus_alsa_buffer_size" mus-alsa-buffer-size) :int)
(defcfun ("mus_alsa_set_buffer_size" mus-alsa-set-buffer-size) :int (size :int))
(defcfun ("mus_alsa_buffers" mus-alsa-buffers) :int)
(defcfun ("mus_alsa_set_buffers" mus-alsa-set-buffers) :int (num :int))
(defcfun ("mus_alsa_squelch_warning" mus-alsa-squelch-warning) :boolean)
(defcfun ("mus_alsa_set_squelch_warning" mus-alsa-set-squelch-warning) :boolean (val :boolean))

(defcfun ("mus_audio_device_channels" mus-audio-device-channels) :int (dev :int))
(defcfun ("mus_audio_device_format" mus-audio-device-format) :int (dev :int))

;; -------- io.c --------

(defcfun ("mus_file_open_descriptors" mus-file-open-descriptors) :int (tfd :int) (arg :string) (df :int) (ds :int) (dl :ullong) (cd :int) (dt :int))
(defcfun ("mus_file_open_read" mus-file-open-read) :int (arg :string))
(defcfun ("mus_file_probe" mus-file-probe) :boolean (arg :string))
(defcfun ("mus_file_open_write" mus-file-open-write) :int (arg :string))
(defcfun ("mus_file_create" mus-file-creat) :int (arg :string))
(defcfun ("mus_file_reopen_write" mus-file-reopen-write) :int (arg :string))
(defcfun ("mus_file_close" mus-file-close) :int (fd :int))
(defcfun ("mus_file_seek_frame" mus-file-seek-frame) :ullong (tfd :int) (frame :ullong))

(defcfun ("mus_file_read" mus-file-read) :ullong (fd :int) (beg :ullong) (end :ullong) (chans :int) (bufs :pointer))

(defcfun ("mus_file_read_chans" mus-file-read-chans) :ullong (fd :int) (beg :ullong) (end :ullong) (chans :int) (bufs :pointer) (cm :pointer))
(defcfun ("mus_file_write" mus-file-write) :int (fd :int) (beg :ullong) (end :ullong) (chans :int) (bufs :pointer))
(defcfun ("mus_file_read_any" mus-file-read-any) :ullong (fd :int) (beg :ullong) (end :ullong) (chans :int) (bufs :pointer) (cm :pointer))
(defcfun ("mus_file_read_file" mus-file-read-file) :ullong (tfd :int) (beg :ullong) (chans :int) (nints :ullong) (bufs :pointer))
(defcfun ("mus_file_read_buffer" mus-file-read-buffer) :ullong (charbuf-data-format :int) (beg :ullong) (chans :int) (nints :ullong) (bufs :pointer) (charbuf :string))
(defcfun ("mus_file_write_file" mus-file-write-file) :int (tfd :int) (beg :ullong) (end :ullong) (chans :int) (bufs :pointer))
(defcfun ("mus_file_write_buffer" mus-file-write-buffer) :int (charbuf-data-format :int) (beg :ullong) (end :ullong) (chans :int) (bufs :pointer) (charbuf :string) (clipped :boolean))
(defcfun ("mus_expand_filename" mus-expand-filename) :string (name :string))
(defcfun ("mus_getcwd" mus-getcwd) :string)

(defcfun ("mus_clipping" mus-clipping) :boolean)
(defcfun ("mus_set_clipping" mus-set-clipping) :boolean (new-value :boolean))
(defcfun ("mus_file_clipping" mus-file-clipping) :boolean (tfd :int))
(defcfun ("mus_file_set_clipping" mus-file-set-clipping) :int (tfd :int) (clipped :boolean))

(defcfun ("mus_file_set_header_type" mus-file-set-header-type) :int (tfd :int) (type :int))
(defcfun ("mus_file_header_type" mus-file-header-type) :int (tfd :int))
(defcfun ("mus_file_fd_name" mus-file-fd-name) :string (tfd :int))
(defcfun ("mus_file_set_chans" mus-file-set-chans) :int (tfd :int) (chans :int))

(defcfun ("mus_file_prescaler" mus-file-prescaler) :ullong (tfd :int))
(defcfun ("mus_file_set_prescaler" mus-file-set-prescaler) :ullong (tfd :int) (val :double))
(defcfun ("mus_prescaler" mus-prescaler) :ullong)
(defcfun ("mus_set_prescaler" mus-set-prescaler) :double (new-value :double))

(defcfun ("mus_iclamp" mus-clamp) :int (lo :int) (val :int) (hi :int))
(defcfun ("mus_oclamp" mus-oclamp) :double (lo :ullong) (val :ullong) (hi :ullong))
(defcfun ("mus_fclamp" mus-fclamp) :double (lo :double) (val :double) (hi :double))

;;todo
;; /* for CLM */
;; /* these are needed to clear a saved lisp image to the just-initialized state */
;; (defcfun void mus_reset_io_c(void);
;; (defcfun void mus_reset_headers_c(void);
;; (defcfun void mus_reset_audio_c(void);

;; (defcfun int mus_samples_peak(unsigned char *data, int bytes, int chans, int format, mus_float_t *maxes);
;; (defcfun int mus_samples_bounds(unsigned char *data, int bytes, int chan, int chans, int format, mus_float_t *min_samp, mus_float_t *max_samp);

;; (defcfun mus_long_t mus_max_malloc(void);
;; (defcfun mus_long_t mus_set_max_malloc(mus_long_t new_max);
;; (defcfun mus_long_t mus_max_table_size(void);
;; (defcfun mus_long_t mus_set_max_table_size(mus_long_t new_max);

;; (defcfun char *mus_strdup(const char *str);
;; (defcfun int mus_strlen(const char *str);
;; (defcfun bool mus_strcmp(const char *str1, const char *str2);
;; (defcfun char *mus_strcat(char *errmsg, const char *str, int *err_size);


;;todo
;; /* -------- headers.c -------- */

;; MUS_EXPORT bool mus_data_format_p(int n);
;; MUS_EXPORT bool mus_header_type_p(int n);

;; MUS_EXPORT mus_long_t mus_header_samples(void);
;; MUS_EXPORT mus_long_t mus_header_data_location(void);
;; MUS_EXPORT int mus_header_chans(void);
;; MUS_EXPORT int mus_header_srate(void);
;; MUS_EXPORT int mus_header_type(void);
;; MUS_EXPORT int mus_header_format(void);
;; MUS_EXPORT mus_long_t mus_header_comment_start(void);
;; MUS_EXPORT mus_long_t mus_header_comment_end(void);
;; MUS_EXPORT int mus_header_type_specifier(void);
;; MUS_EXPORT int mus_header_bits_per_sample(void);
;; MUS_EXPORT int mus_header_fact_samples(void);
;; MUS_EXPORT int mus_header_block_align(void);
;; MUS_EXPORT int mus_header_loop_mode(int which);
;; MUS_EXPORT int mus_header_loop_start(int which);
;; MUS_EXPORT int mus_header_loop_end(int which);
;; MUS_EXPORT int mus_header_mark_position(int id);
;; MUS_EXPORT int mus_header_mark_info(int **marker_ids, int **marker_positions);
;; MUS_EXPORT int mus_header_base_note(void);
;; MUS_EXPORT int mus_header_base_detune(void);
;; MUS_EXPORT void mus_header_set_raw_defaults(int sr, int chn, int frm);
;; MUS_EXPORT void mus_header_raw_defaults(int *sr, int *chn, int *frm);
;; MUS_EXPORT mus_long_t mus_header_true_length(void);
;; MUS_EXPORT int mus_header_original_format(void);
;; MUS_EXPORT mus_long_t mus_samples_to_bytes(int format, mus_long_t size);
;; MUS_EXPORT mus_long_t mus_bytes_to_samples(int format, mus_long_t size);
;; MUS_EXPORT int mus_header_read(const char *name);
;; MUS_EXPORT int mus_header_write(const char *name, int type, int srate, int chans, mus_long_t loc, mus_long_t size_in_samples, int format, const char *comment, int len);
;; MUS_EXPORT int mus_write_header(const char *name, int type, int in_srate, int in_chans, mus_long_t size_in_samples, int format, const char *comment);
;; MUS_EXPORT mus_long_t mus_header_aux_comment_start(int n);
;; MUS_EXPORT mus_long_t mus_header_aux_comment_end(int n);
;; MUS_EXPORT int mus_header_initialize(void);
;; MUS_EXPORT bool mus_header_writable(int type, int format);
;; MUS_EXPORT void mus_header_set_aiff_loop_info(int *data);
;; MUS_EXPORT int mus_header_sf2_entries(void);
;; MUS_EXPORT char *mus_header_sf2_name(int n);
;; MUS_EXPORT int mus_header_sf2_start(int n);
;; MUS_EXPORT int mus_header_sf2_end(int n);
;; MUS_EXPORT int mus_header_sf2_loop_start(int n);
;; MUS_EXPORT int mus_header_sf2_loop_end(int n);
;; MUS_EXPORT const char *mus_header_original_format_name(int format, int type);
;; MUS_EXPORT bool mus_header_no_header(const char *name);

;; MUS_EXPORT char *mus_header_riff_aux_comment(const char *name, mus_long_t *starts, mus_long_t *ends);
;; MUS_EXPORT char *mus_header_aiff_aux_comment(const char *name, mus_long_t *starts, mus_long_t *ends);

;; MUS_EXPORT int mus_header_change_chans(const char *filename, int type, int new_chans);
;; MUS_EXPORT int mus_header_change_srate(const char *filename, int type, int new_srate);
;; MUS_EXPORT int mus_header_change_type(const char *filename, int new_type, int new_format);
;; MUS_EXPORT int mus_header_change_format(const char *filename, int type, int new_format);
;; MUS_EXPORT int mus_header_change_location(const char *filename, int type, mus_long_t new_location);
;; MUS_EXPORT int mus_header_change_comment(const char *filename, int type, const char *new_comment);
;; MUS_EXPORT int mus_header_change_data_size(const char *filename, int type, mus_long_t bytes);

;; typedef void mus_header_write_hook_t(const char *filename);
;; MUS_EXPORT mus_header_write_hook_t *mus_header_write_set_hook(mus_header_write_hook_t *new_hook);
