;;todo
;; enum {MUS_UNSUPPORTED, MUS_NEXT, MUS_AIFC, MUS_RIFF, MUS_RF64, MUS_BICSF, MUS_NIST, MUS_INRS, MUS_ESPS, MUS_SVX, MUS_VOC, 
;;       MUS_SNDT, MUS_RAW, MUS_SMP, MUS_AVR, MUS_IRCAM, MUS_SD1, MUS_SPPACK, MUS_MUS10, MUS_HCOM, MUS_PSION, MUS_MAUD,
;;       MUS_IEEE, MUS_MATLAB, MUS_ADC, MUS_MIDI, MUS_SOUNDFONT, MUS_GRAVIS, MUS_COMDISCO, MUS_GOLDWAVE, MUS_SRFS,
;;       MUS_MIDI_SAMPLE_DUMP, MUS_DIAMONDWARE, MUS_ADF, MUS_SBSTUDIOII, MUS_DELUSION,
;;       MUS_FARANDOLE, MUS_SAMPLE_DUMP, MUS_ULTRATRACKER, MUS_YAMAHA_SY85, MUS_YAMAHA_TX16W, MUS_DIGIPLAYER,
;;       MUS_COVOX, MUS_AVI, MUS_OMF, MUS_QUICKTIME, MUS_ASF, MUS_YAMAHA_SY99, MUS_KURZWEIL_2000,
;;       MUS_AIFF, MUS_PAF, MUS_CSL, MUS_FILE_SAMP, MUS_PVF, MUS_SOUNDFORGE, MUS_TWINVQ, MUS_AKAI4,
;;       MUS_IMPULSETRACKER, MUS_KORG, MUS_NVF, MUS_CAFF, MUS_MAUI, MUS_SDIF, MUS_OGG, MUS_FLAC, MUS_SPEEX, MUS_MPEG,
;;       MUS_SHORTEN, MUS_TTA, MUS_WAVPACK,  MUS_SOX,
;;       MUS_NUM_HEADER_TYPES};


;; enum {MUS_UNKNOWN, MUS_BSHORT, MUS_MULAW, MUS_BYTE, MUS_BFLOAT, MUS_BINT, MUS_ALAW, MUS_UBYTE, MUS_B24INT,
;;       MUS_BDOUBLE, MUS_LSHORT, MUS_LINT, MUS_LFLOAT, MUS_LDOUBLE, MUS_UBSHORT, MUS_ULSHORT, MUS_L24INT,
;;       MUS_BINTN, MUS_LINTN, MUS_BFLOAT_UNSCALED, MUS_LFLOAT_UNSCALED, MUS_BDOUBLE_UNSCALED, MUS_LDOUBLE_UNSCALED,
;;       MUS_NUM_DATA_FORMATS};


;; enum {MUS_NO_ERROR, MUS_NO_FREQUENCY, MUS_NO_PHASE, MUS_NO_GEN, MUS_NO_LENGTH,
;;       MUS_NO_FREE, MUS_NO_DESCRIBE, MUS_NO_DATA, MUS_NO_SCALER,
;;       MUS_MEMORY_ALLOCATION_FAILED, MUS_UNSTABLE_TWO_POLE_ERROR,
;;       MUS_CANT_OPEN_FILE, MUS_NO_SAMPLE_INPUT, MUS_NO_SAMPLE_OUTPUT,
;;       MUS_NO_SUCH_CHANNEL, MUS_NO_FILE_NAME_PROVIDED, MUS_NO_LOCATION, MUS_NO_CHANNEL,
;;       MUS_NO_SUCH_FFT_WINDOW, MUS_UNSUPPORTED_DATA_FORMAT, MUS_HEADER_READ_FAILED,
;;       MUS_UNSUPPORTED_HEADER_TYPE,
;;       MUS_FILE_DESCRIPTORS_NOT_INITIALIZED, MUS_NOT_A_SOUND_FILE, MUS_FILE_CLOSED, MUS_WRITE_ERROR,
;;       MUS_HEADER_WRITE_FAILED, MUS_CANT_OPEN_TEMP_FILE, MUS_INTERRUPTED, MUS_BAD_ENVELOPE,

;;       MUS_AUDIO_CHANNELS_NOT_AVAILABLE, MUS_AUDIO_SRATE_NOT_AVAILABLE, MUS_AUDIO_FORMAT_NOT_AVAILABLE,
;;       MUS_AUDIO_NO_INPUT_AVAILABLE, MUS_AUDIO_CONFIGURATION_NOT_AVAILABLE, 
;;       MUS_AUDIO_WRITE_ERROR, MUS_AUDIO_SIZE_NOT_AVAILABLE, MUS_AUDIO_DEVICE_NOT_AVAILABLE,
;;       MUS_AUDIO_CANT_CLOSE, MUS_AUDIO_CANT_OPEN, MUS_AUDIO_READ_ERROR, 
;;       MUS_AUDIO_CANT_WRITE, MUS_AUDIO_CANT_READ, MUS_AUDIO_NO_READ_PERMISSION,

;;       MUS_CANT_CLOSE_FILE, MUS_ARG_OUT_OF_RANGE, MUS_WRONG_TYPE_ARG,
;;       MUS_NO_CHANNELS, MUS_NO_HOP, MUS_NO_WIDTH, MUS_NO_FILE_NAME, MUS_NO_RAMP, MUS_NO_RUN, 
;;       MUS_NO_INCREMENT, MUS_NO_OFFSET,
;;       MUS_NO_XCOEFF, MUS_NO_YCOEFF, MUS_NO_XCOEFFS, MUS_NO_YCOEFFS, MUS_NO_RESET, MUS_BAD_SIZE, MUS_CANT_CONVERT,
;;       MUS_READ_ERROR, MUS_NO_SAFETY,
;;       MUS_INITIAL_ERROR_TAG};



;;;;-------- sound.c --------

(defcfun ("mus_error" mus-error) :int (error :int) (format :string))
(defcfun ("mus_print" mus-print) :void (format :string))
(defcfun ("mus_format" mus-format) :pointer (format :string))
(defcfun ("mus_snprintf" mus-sndprintf) :void (buffer :string) (buffer-len :int) (format :string))

;todo
;; typedef void mus_error_handler_t(int type, char *msg);
;; MUS_EXPORT mus_error_handler_t *mus_error_set_handler(mus_error_handler_t *new_error_handler);
;; MUS_EXPORT int mus_make_error(const char *error_name);
;; MUS_EXPORT const char *mus_error_type_to_string(int err);

;; typedef void mus_print_handler_t(char *msg);
;; MUS_EXPORT mus_print_handler_t *mus_print_set_handler(mus_print_handler_t *new_print_handler);

;; typedef mus_sample_t mus_clip_handler_t(mus_sample_t val);
;; MUS_EXPORT mus_clip_handler_t *mus_clip_set_handler(mus_clip_handler_t *new_clip_handler);

(defcfun ("mus_sound_samples" mus-sound-samples) :double (arg :string))
(defcfun ("mus_sound_frames" mus-sound-frames) :double (arg :string))
(defcfun ("mus_sound_datum_size" mus-sound-datum-size) :int (arg :string))
(defcfun ("mus_sound_data_location" mus-sound-data-location) :double (arg :string))
(defcfun ("mus_sound_chans" mus-sound-chans) :int (arg :string))
(defcfun ("mus_sound_srate" mus-sound-srate) :int (arg :string))
(defcfun ("mus_sound_header_type" msu-sound-header-type) :int (arg :string))
(defcfun ("mus_sound_data_format" mus-sound-data-format) :int (arg :string))
(defcfun ("mus_sound_original_format" mus-sound-original-format) :int (arg :string))
(defcfun ("mus_sound_comment_start" mus-sound-comment-start) :double (arg :string))
(defcfun ("mus_sound_comment_end" mus-sound-comment-end) :double (arg :string))
(defcfun ("mus_sound_length" mus-sound-length) :double (arg :string))
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
(defcfun ("mus_data_format_name" mus-data-format-name) :string (format :int))
(defcfun ("mus_header_type_to_string" mus-header-type-to-string) :string (type :int))
(defcfun ("mus_data_format_to_string" mus-data-format-to-string) :string (format :int))
(defcfun ("mus_data_format_short_name" mus-data-format-short-name) :string (format :int))
(defcfun ("mus_sound_comment" mus-sound-comment) :string (name :string))
(defcfun ("mus_bytes_per_sample" mus-bytes-per-sample) :int (format :int))
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

;TODO
;#define mus_sound_seek_frame(Ifd, Frm) mus_file_seek_frame(Ifd, Frm)
;#define mus_sound_read(Fd, Beg, End, Chans, Bufs) mus_file_read(Fd, Beg, End, Chans, Bufs)
;#define mus_sound_write(Fd, Beg, End, Chans, Bufs) mus_file_write(Fd, Beg, End, Chans, Bufs)

(defcfun ("mus_sound_maxamps" mus-sound-maxamps) :double (ifile :string) (chans :int) (vals (:pointer :double)) (times (:pointer :double)))
(defcfun ("mus_sound_set_maxamps" mus-sound-set-maxamps) :int (ifile :string) (chans :int) (vals (:pointer :double)) (times (:pointer :double)))
(defcfun ("mus_sound_maxamp_exists" mus-sound-maxamp-exists) :bool (ifile :string))

;todo
;(defcfun ("mus_file_to_array" mus-file-to-array) :double (filename :string) (chan :int) (start :double) (samples :double) (array (:pointer :sample))) ;;todo mus_sample_t
;(defcfun int mus_array_to_file :int (const char *filename, mus_sample_t *ddata, mus_long_t len, int srate, int channels);
;(defcfun const char *mus_array_to_file_with_error :string (const char *filename, mus_sample_t *ddata, mus_long_t len, int srate, int channels);
;(defcfun mus_long_t mus_file_to_float_array :double (const char *filename, int chan, mus_long_t start, mus_long_t samples, mus_float_t *array);
;(defcfun int mus_float_array_to_file :int (const char *filename, mus_float_t *ddata, mus_long_t len, int srate, int channels);



/* -------- audio.c -------- */

MUS_EXPORT char *mus_audio_describe(void);
MUS_EXPORT int mus_audio_open_output(int dev, int srate, int chans, int format, int size);
MUS_EXPORT int mus_audio_open_input(int dev, int srate, int chans, int format, int size);
MUS_EXPORT int mus_audio_write(int line, char *buf, int bytes);
MUS_EXPORT int mus_audio_close(int line);
MUS_EXPORT int mus_audio_read(int line, char *buf, int bytes);

MUS_EXPORT int mus_audio_write_buffers(int line, int frames, int chans, mus_sample_t **bufs, int output_format, bool clipped);
MUS_EXPORT int mus_audio_read_buffers(int line, int frames, int chans, mus_sample_t **bufs, int input_format);
MUS_EXPORT int mus_audio_initialize(void);
MUS_EXPORT int mus_audio_reinitialize(void); /* 29-Aug-01 for CLM/Snd bugfix? */
MUS_EXPORT int mus_audio_systems(void);
MUS_EXPORT char *mus_audio_moniker(void);
MUS_EXPORT int mus_audio_api(void);
MUS_EXPORT int mus_audio_compatible_format(int dev);

MUS_EXPORT void mus_oss_set_buffers(int num, int size);

MUS_EXPORT char *mus_alsa_playback_device(void);
MUS_EXPORT char *mus_alsa_set_playback_device(const char *name);
MUS_EXPORT char *mus_alsa_capture_device(void);
MUS_EXPORT char *mus_alsa_set_capture_device(const char *name);
MUS_EXPORT char *mus_alsa_device(void);
MUS_EXPORT char *mus_alsa_set_device(const char *name);
MUS_EXPORT int mus_alsa_buffer_size(void);
MUS_EXPORT int mus_alsa_set_buffer_size(int size);
MUS_EXPORT int mus_alsa_buffers(void);
MUS_EXPORT int mus_alsa_set_buffers(int num);
MUS_EXPORT bool mus_alsa_squelch_warning(void);
MUS_EXPORT bool mus_alsa_set_squelch_warning(bool val);

MUS_EXPORT int mus_audio_device_channels(int dev);
MUS_EXPORT int mus_audio_device_format(int dev);



/* -------- io.c -------- */

MUS_EXPORT int mus_file_open_descriptors(int tfd, const char *arg, int df, int ds, mus_long_t dl, int dc, int dt);
MUS_EXPORT int mus_file_open_read(const char *arg);
MUS_EXPORT bool mus_file_probe(const char *arg);
MUS_EXPORT int mus_file_open_write(const char *arg);
MUS_EXPORT int mus_file_create(const char *arg);
MUS_EXPORT int mus_file_reopen_write(const char *arg);
MUS_EXPORT int mus_file_close(int fd);
MUS_EXPORT mus_long_t mus_file_seek_frame(int tfd, mus_long_t frame);
MUS_EXPORT mus_long_t mus_file_read(int fd, mus_long_t beg, mus_long_t end, int chans, mus_sample_t **bufs);
MUS_EXPORT mus_long_t mus_file_read_chans(int fd, mus_long_t beg, mus_long_t end, int chans, mus_sample_t **bufs, mus_sample_t **cm);
MUS_EXPORT int mus_file_write(int tfd, mus_long_t beg, mus_long_t end, int chans, mus_sample_t **bufs);
MUS_EXPORT mus_long_t mus_file_read_any(int tfd, mus_long_t beg, int chans, mus_long_t nints, mus_sample_t **bufs, mus_sample_t **cm);
MUS_EXPORT mus_long_t mus_file_read_file(int tfd, mus_long_t beg, int chans, mus_long_t nints, mus_sample_t **bufs);
MUS_EXPORT mus_long_t mus_file_read_buffer(int charbuf_data_format, mus_long_t beg, int chans, mus_long_t nints, mus_sample_t **bufs, char *charbuf);
MUS_EXPORT int mus_file_write_file(int tfd, mus_long_t beg, mus_long_t end, int chans, mus_sample_t **bufs);
MUS_EXPORT int mus_file_write_buffer(int charbuf_data_format, mus_long_t beg, mus_long_t end, int chans, mus_sample_t **bufs, char *charbuf, bool clipped);
MUS_EXPORT char *mus_expand_filename(const char *name);
MUS_EXPORT char *mus_getcwd(void);

MUS_EXPORT bool mus_clipping(void);
MUS_EXPORT bool mus_set_clipping(bool new_value);
MUS_EXPORT bool mus_file_clipping(int tfd);
MUS_EXPORT int mus_file_set_clipping(int tfd, bool clipped);

MUS_EXPORT int mus_file_set_header_type(int tfd, int type);
MUS_EXPORT int mus_file_header_type(int tfd);
MUS_EXPORT char *mus_file_fd_name(int tfd);
MUS_EXPORT int mus_file_set_chans(int tfd, int chans);

MUS_EXPORT mus_float_t mus_file_prescaler(int tfd);
MUS_EXPORT mus_float_t mus_file_set_prescaler(int tfd, mus_float_t val);
MUS_EXPORT mus_float_t mus_prescaler(void);
MUS_EXPORT mus_float_t mus_set_prescaler(mus_float_t new_value);

MUS_EXPORT int mus_iclamp(int lo, int val, int hi);
MUS_EXPORT mus_long_t mus_oclamp(mus_long_t lo, mus_long_t val, mus_long_t hi);
MUS_EXPORT mus_float_t mus_fclamp(mus_float_t lo, mus_float_t val, mus_float_t hi);

/* for CLM */
/* these are needed to clear a saved lisp image to the just-initialized state */
MUS_EXPORT void mus_reset_io_c(void);
MUS_EXPORT void mus_reset_headers_c(void);
MUS_EXPORT void mus_reset_audio_c(void);

MUS_EXPORT int mus_samples_peak(unsigned char *data, int bytes, int chans, int format, mus_float_t *maxes);
MUS_EXPORT int mus_samples_bounds(unsigned char *data, int bytes, int chan, int chans, int format, mus_float_t *min_samp, mus_float_t *max_samp);

MUS_EXPORT mus_long_t mus_max_malloc(void);
MUS_EXPORT mus_long_t mus_set_max_malloc(mus_long_t new_max);
MUS_EXPORT mus_long_t mus_max_table_size(void);
MUS_EXPORT mus_long_t mus_set_max_table_size(mus_long_t new_max);

MUS_EXPORT char *mus_strdup(const char *str);
MUS_EXPORT int mus_strlen(const char *str);
MUS_EXPORT bool mus_strcmp(const char *str1, const char *str2);
MUS_EXPORT char *mus_strcat(char *errmsg, const char *str, int *err_size);


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
