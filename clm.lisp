(in-package #:zvuk)

;;todo
;; #ifndef CLM_H
;; #define CLM_H

;; #define MUS_VERSION 4
;; #define MUS_REVISION 33
;; #define MUS_DATE "1-Sep-11"

;; /* isn't mus_env_interp backwards? */

;; #include "sndlib.h"

;; #if HAVE_COMPLEX_TRIG
;; #include <complex.h>
;; #endif

;; #if(!defined(M_PI))
;;   #define M_PI 3.14159265358979323846264338327
;;   #define M_PI_2 (M_PI / 2.0)
;; #endif

;; #define MUS_DEFAULT_SAMPLING_RATE 44100.0
;; #define MUS_DEFAULT_FILE_BUFFER_SIZE 8192
;; #define MUS_DEFAULT_ARRAY_PRINT_LENGTH 8

;; typedef enum {MUS_NOT_SPECIAL, MUS_SIMPLE_FILTER, MUS_FULL_FILTER, MUS_OUTPUT, MUS_INPUT, MUS_DELAY_LINE} mus_clm_extended_t;

;; typedef struct {
;;   struct mus_any_class *core;
;; } mus_any;

;; typedef struct mus_any_class {
;;   int type;
;;   char *name;
;;   int (*release)(mus_any *ptr);
;;   char *(*describe)(mus_any *ptr);                            /* caller should free the string */
;;   bool (*equalp)(mus_any *gen1, mus_any *gen2);
;;   mus_float_t *(*data)(mus_any *ptr);
;;   mus_float_t *(*set_data)(mus_any *ptr, mus_float_t *new_data);
;;   mus_long_t (*length)(mus_any *ptr);
;;   mus_long_t (*set_length)(mus_any *ptr, mus_long_t new_length);
;;   mus_float_t (*frequency)(mus_any *ptr);
;;   mus_float_t (*set_frequency)(mus_any *ptr, mus_float_t new_freq);
;;   mus_float_t (*phase)(mus_any *ptr); 
;;   mus_float_t (*set_phase)(mus_any *ptr, mus_float_t new_phase);
;;   mus_float_t (*scaler)(mus_any *ptr);
;;   mus_float_t (*set_scaler)(mus_any *ptr, mus_float_t val);
;;   mus_float_t (*increment)(mus_any *ptr);
;;   mus_float_t (*set_increment)(mus_any *ptr, mus_float_t val);
;;   mus_float_t (*run)(mus_any *gen, mus_float_t arg1, mus_float_t arg2);
;;   mus_clm_extended_t extended_type;
;;   void *(*closure)(mus_any *gen);
;;   int (*channels)(mus_any *ptr);
;;   mus_float_t (*offset)(mus_any *ptr);
;;   mus_float_t (*set_offset)(mus_any *ptr, mus_float_t val);
;;   mus_float_t (*width)(mus_any *ptr);
;;   mus_float_t (*set_width)(mus_any *ptr, mus_float_t val);
;;   mus_float_t (*xcoeff)(mus_any *ptr, int index);
;;   mus_float_t (*set_xcoeff)(mus_any *ptr, int index, mus_float_t val);
;;   mus_long_t (*hop)(mus_any *ptr);
;;   mus_long_t (*set_hop)(mus_any *ptr, mus_long_t new_length);
;;   mus_long_t (*ramp)(mus_any *ptr);
;;   mus_long_t (*set_ramp)(mus_any *ptr, mus_long_t new_length);
;;   mus_float_t (*read_sample)(mus_any *ptr, mus_long_t samp, int chan);
;;   mus_float_t (*write_sample)(mus_any *ptr, mus_long_t samp, int chan, mus_float_t data);
;;   char *(*file_name)(mus_any *ptr);
;;   int (*end)(mus_any *ptr);
;;   mus_long_t (*location)(mus_any *ptr);
;;   mus_long_t (*set_location)(mus_any *ptr, mus_long_t loc);
;;   int (*channel)(mus_any *ptr);
;;   mus_float_t (*ycoeff)(mus_any *ptr, int index);
;;   mus_float_t (*set_ycoeff)(mus_any *ptr, int index, mus_float_t val);
;;   mus_float_t *(*xcoeffs)(mus_any *ptr);
;;   mus_float_t *(*ycoeffs)(mus_any *ptr);
;;   void *original_class; /* class chain perhaps */
;;   void (*reset)(mus_any *ptr);
;;   void *(*set_closure)(mus_any *gen, void *e);
;;   int (*safety)(mus_any *ptr);
;;   int (*set_safety)(mus_any *ptr, int val);
;; } mus_any_class;


(defcenum :mus-interp
    :none :linear :sinusoidal :all-pass 
    :lagrange :bezier :hermite :num-interps)

(defcenum :mus-env
    :mus-env-linear :mus-env-exponential :mus-env-step)

(defcenum :mus-fft-window-type
    :mus-rectangular-window :mus-hann-window :mus-welch-window :mus-parzen-window :mus-bartlett-window 
    :mus-hamming-window :mus-blackman2-window :mus-blackman3-window :mus-blackman4-window :mus-exponential-window
    :mus-riemann-window :mus-kaiser-window :mus-cauchy-window :mus-poisson-window :mus-gaussian-window 
    :mus-tukey-window :mus-dolph-chebyshev-window :mus-hann-poisson-window :mus-connes-window :mus-samaraki-window 
    :mus-ultraspherical-window :mus-bartlett-hann-window :mus-bohman-window :mus-flat-top-window :mus-blackman5-window 
    :mus-blackman6-window :mus-blackman7-window :mus-blackman8-window :mus-blackman9-window :mus-blackman10-window
    :mus-rv2-window :mus-rv3-window :mus-rv4-window :mus-mlt-sine-window :mus-papoulis-window :mus-dpss-window :mus-sinc-window
    :mus-num-fft-windows)

(defcenum :mus-spectrum-type 
    :mus-spectrum-in-db :mus-spectrum-normalized :mus-spectrum-raw)

(defcenum :mus-polynomial
    :mus-chebyshev-either-kind :mus-chebyshev-first-kind :mus-chebyshev-second-kind)

;; #if defined(__GNUC__) && (!(defined(__cplusplus)))
;;   #define MUS_RUN(GEN, ARG_1, ARG_2) ({ mus_any *_clm_h_1 = (mus_any *)(GEN); \
;;                                        ((*((_clm_h_1->core)->run))(_clm_h_1, ARG_1, ARG_2)); })
;; #else
;;   #define MUS_RUN(GEN, ARG_1, ARG_2) ((*(((GEN)->core)->run))(GEN, ARG_1, ARG_2))
;; #endif
;; #define MUS_RUN_P(GEN) (((GEN)->core)->run)
;; #define MUS_MAX_CLM_SINC_WIDTH 65536
;; #define MUS_MAX_CLM_SRC 65536.0

(defcfun ("mus_initialize" mus-initialize) :void)

(defcfun ("mus_make_class_tag" mus-make-class-tag) :int)
(defcfun ("mus_radians_to_hz" mus-radians-to-hz) :double (radians :double))
(defcfun ("mus_hz_to_radians" mus-hz-to-radians) :double (hz :double))
(defcfun ("mus_degrees_to_radians" mus-degrees-to-radians) :double (degrees :double))
(defcfun ("mus_radians_to_degrees" mus-radians-to-degrees) :double (radians :double))
(defcfun ("mus_db_to_linear" mus-db-to-linear) :double (x :double))
(defcfun ("mus_linear_to_db" mus-linear-to-db) :double (x :double))

(defcfun ("mus_srate" mus-srate) :double)
(defcfun ("mus_set_srate" mus-set-srate) :double (val :double))
(defcfun ("mus_seconds_to_samples" mus-seconds-to-samples) :ullong (secs :double))
(defcfun ("mus_samples_to_seconds" mus-samples-to-seconds) :double (samps :ullong))
(defcfun ("mus_array_print_length" mus-array-print-length) :int)
(defcfun ("mus_set_array_print_length" mus-set-array-print-length) :int (val :int))
(defcfun ("mus_float_equal_fudge_factor" mus-float-equal-fudge-factor) :double)
(defcfun ("mus_set_float_equal_fudge_factor" mus-set-float-equal-fudge-factor) :double (val :double))

(defcfun ("mus_ring_modulate" mus-ring-modulate) :double (s1 :double) (s2 :double))
(defcfun ("mus_amplitude_modulate" mus-amplitude-modulate) :double (s1 :double) (s2 :double) (s3 :double))
(defcfun ("mus_contrast_enhancement" mus-contrast-enhancement) :double (sig :double) (index :double))
(defcfun ("mus_dot_product" mus-dot-product) :double (data1 (:pointer :double)) (data2 (:pointer :double)) (size :ullong))

(defcfun ("mus_clear_array" mus-clear-array) :void (arr (:pointer :double)) (size :ullong))
(defcfun ("mus_arrays_are_equal" mus-arrays-are-equal) :boolean (arr1 (:pointer :double)) (arr2 (:pointer :double)) (fudge :double) (leng :ullong))
(defcfun ("mus_polynomial" mus-polynomial) :double (coeffs (:pointer :double)) (x :double) (ncoeffs :int))
(defcfun ("mus_multiply_arrays" mus-multiply-arrays) :void (data (:pointer :double)) (window (:pointer :double)) (len :ullong))
(defcfun ("mus_rectangular_to_polar" mus-rectangular-to-polar) :void (r1 (:pointer :double)) (im (:pointer :double)) (size :ullong))
(defcfun ("mus_rectangular_to_magnitudes" mus-rectangular-to-magnitudes) :void (rl (:pointer :double)) (im (:pointer :double)) (size :ullong))
(defcfun ("mus_polar_to_rectangular" mus-polar-to-rectangular) :void (rl (:pointer :double)) (im (:pointer :double)) (size :ullong))
(defcfun ("mus_array_interp" mus-array-interp) :double (wave (:pointer :double)) (phase :double) (size :ullong))
(defcfun ("mus_bessi0" mus-bessi0) :double (x :double))
(defcfun ("mus_interpolate" mus-interpolate) :double (type :mus-interp) (x :double) (table (:pointer :double)) (table-size :ullong) (y :double))
(defcfun ("mus_interp_type_p" mus-interp-type-p) :boolean (val :int))
(defcfun ("mus_fft_window_p" mus-fft-window-p) :boolean (val :int))

(defcfun ("mus_data_format_zero" mus-data-format-zero) :int (format :int))


;; /* -------- generic functions -------- */

;; MUS_EXPORT int mus_type(mus_any *ptr);
;; MUS_EXPORT int mus_free(mus_any *ptr);
;; MUS_EXPORT char *mus_describe(mus_any *gen);
;; MUS_EXPORT bool mus_equalp(mus_any *g1, mus_any *g2);
;; MUS_EXPORT mus_float_t mus_phase(mus_any *gen);
;; MUS_EXPORT mus_float_t mus_set_phase(mus_any *gen, mus_float_t val);
;; MUS_EXPORT mus_float_t mus_set_frequency(mus_any *gen, mus_float_t val);
;; MUS_EXPORT mus_float_t mus_frequency(mus_any *gen);
;; MUS_EXPORT mus_float_t mus_run(mus_any *gen, mus_float_t arg1, mus_float_t arg2);
;; MUS_EXPORT mus_long_t mus_length(mus_any *gen);
;; MUS_EXPORT mus_long_t mus_set_length(mus_any *gen, mus_long_t len);
;; MUS_EXPORT mus_long_t mus_order(mus_any *gen);
;; MUS_EXPORT mus_float_t *mus_data(mus_any *gen);
;; MUS_EXPORT mus_float_t *mus_set_data(mus_any *gen, mus_float_t *data);
;; MUS_EXPORT const char *mus_name(mus_any *ptr);
;; MUS_EXPORT const char *mus_set_name(mus_any *ptr, const char *new_name);
;; MUS_EXPORT mus_float_t mus_scaler(mus_any *gen);
;; MUS_EXPORT mus_float_t mus_set_scaler(mus_any *gen, mus_float_t val);
;; MUS_EXPORT mus_float_t mus_offset(mus_any *gen);
;; MUS_EXPORT mus_float_t mus_set_offset(mus_any *gen, mus_float_t val);
;; MUS_EXPORT mus_float_t mus_width(mus_any *gen);
;; MUS_EXPORT mus_float_t mus_set_width(mus_any *gen, mus_float_t val);
;; MUS_EXPORT char *mus_file_name(mus_any *ptr);
;; MUS_EXPORT void mus_reset(mus_any *ptr);
;; MUS_EXPORT mus_float_t *mus_xcoeffs(mus_any *ptr);
;; MUS_EXPORT mus_float_t *mus_ycoeffs(mus_any *ptr);
;; MUS_EXPORT mus_float_t mus_xcoeff(mus_any *ptr, int index);
;; MUS_EXPORT mus_float_t mus_set_xcoeff(mus_any *ptr, int index, mus_float_t val);
;; MUS_EXPORT mus_float_t mus_ycoeff(mus_any *ptr, int index);
;; MUS_EXPORT mus_float_t mus_set_ycoeff(mus_any *ptr, int index, mus_float_t val);
;; MUS_EXPORT mus_float_t mus_increment(mus_any *rd);
;; MUS_EXPORT mus_float_t mus_set_increment(mus_any *rd, mus_float_t dir);
;; MUS_EXPORT mus_long_t mus_location(mus_any *rd);
;; MUS_EXPORT mus_long_t mus_set_location(mus_any *rd, mus_long_t loc);
;; MUS_EXPORT int mus_channel(mus_any *rd);
;; MUS_EXPORT int mus_channels(mus_any *ptr);
;; MUS_EXPORT int mus_position(mus_any *ptr); /* only C, envs (snd-env.c), shares slot with mus_channels */
;; MUS_EXPORT int mus_interp_type(mus_any *ptr);
;; MUS_EXPORT mus_long_t mus_ramp(mus_any *ptr);
;; MUS_EXPORT mus_long_t mus_set_ramp(mus_any *ptr, mus_long_t val);
;; MUS_EXPORT mus_long_t mus_hop(mus_any *ptr);
;; MUS_EXPORT mus_long_t mus_set_hop(mus_any *ptr, mus_long_t val);
;; MUS_EXPORT mus_float_t mus_feedforward(mus_any *gen);
;; MUS_EXPORT mus_float_t mus_set_feedforward(mus_any *gen, mus_float_t val);
;; MUS_EXPORT mus_float_t mus_feedback(mus_any *rd);
;; MUS_EXPORT mus_float_t mus_set_feedback(mus_any *rd, mus_float_t dir);
;; MUS_EXPORT int mus_safety(mus_any *gen);
;; MUS_EXPORT int mus_set_safety(mus_any *gen, int val);


;; /* -------- generators -------- */

(defcfun ("mus_oscil" mus-oscil) :double (o :pointer) (fm :double) (pm :double))
(defcfun ("mus_oscil_unmodulated" mus-oscil-unmodulated) :double (ptr :pointer))
(defcfun ("mus_oscil_fm" mus-oscil-fm) :double (ptr :pointer) (fm :double))
(defcfun ("mus_oscil_pm" mus-oscil-pm) :double (ptr :pointer) (pm :double))
(defcfun ("mus_oscil_p" mus-oscil-p) :boolean (ptr :pointer))
(defcfun ("mus_make_oscil" mus-make-oscil) :pointer (freq :double) (phase :double))

(defcfun ("mus_make_ncos" mus-make-ncos) :pointer (freq :double) (n :int))
(defcfun ("mus_ncos" mus-ncos) :double (ptr :pointer) (fm :double))
(defcfun ("mus_ncos_p" mus-ncso-p) :boolean (ptr :pointer))

(defcfun ("mus_make_nsin" mus-make-nsin) :pointer (freq :double) (n :int))
(defcfun ("mus_nsin" mus-nsin) :double (ptr :pointer) (fm :double))
(defcfun ("mus_nsin_p" mus-nsin-p) :boolean (ptr :pointer))

(defcfun ("mus_make_nrxysin" mus-make-nrxysin) :pointer (frequency :double) (y_over_x :double) (n :int) (r :double))
(defcfun ("mus_nrxysin" mus-nrxysin) :double (ptr :pointer) (fm :double))
(defcfun ("mus_nrxysin_p" mus-nrxysin-p) :boolean (ptr :pointer))

(defcfun ("mus_make_nrxycos" mus-make-nrxycos) :pointer (frequency :double) (y_over_x :double) (n :int) (r :double))
(defcfun ("mus_nrxycos" mus-nrxycos) :double (ptr :pointer) (fm :double))
(defcfun ("mus_nrxycos_p" mus-nrxycos-p) :boolean (ptr :pointer))

(defcfun ("mus_delay" mus-delay) :double (gen :pointer) (input :double) (pm :double))
(defcfun ("mus_delay_unmodulated" mus-delay-unmodulated) :double (ptr :pointer) (input :double))
(defcfun ("mus_tap" mus-tap) :double (gen :pointer) (loc :double))
(defcfun ("mus_tap_unmodulated" mus-tap-unmodulated) :double (gen :pointer))
(defcfun ("mus_make_delay" mus-make-delay) :pointer (size :int) (line (:pointer :double)) (line-size :int) (type :mus-interp))
(defcfun ("mus_delay_p" mus-delay-p) :boolean (ptr :pointer))
(defcfun ("mus_delay_line_p" mus-delay-line-p) :boolean (gen :pointer))
(defcfun ("mus_delay_tick" mus-delay-tick) :double (ptr :pointer) (input :double))
(defcfun ("mus_delay_tick_noz" mus-delay-tick-noz) :double (ptr :pointer) (input :double))
(defcfun ("mus_delay_unmodulated_noz" mus-delay-unmodulated-noz) :double (ptr :pointer) (input :double))

(defcfun ("mus_comb" mus-comb) :double (gen :pointer) (input :double) (pm :double))
(defcfun ("mus_comb_unmodulated" mus-comb-unmodulated) :double (gen :pointer) (input :double))
(defcfun ("mus_make_comb" mus-make-comb) :pointer (scaler :double) (size :int) (line (:pointer :double)) (line-size :int) (type :mus-interp))
(defcfun ("mus_comb_p" mus-comb-p) :boolean (ptr :pointer))
(defcfun ("mus_comb_unmodulated_noz" mus-comb-unmodulated-noz) :double (ptr :pointer) (input :double))

(defcfun ("mus_notch" mus-notch) :double (gen :pointer) (input :double) (pm :double))
(defcfun ("mus_notch_unmodulated" mus-notch-unmodulated) :double (gen :pointer) (input :double))
(defcfun ("mus_make_notch" mus-make-notch) :pointer (scaler :double) (size :int) (line :pointer :double) (line-size :int) (type :mus-interp))
(defcfun ("mus_notch_p" mus-notch-p) :boolean (ptr :pointer))
(defcfun ("mus_notch_unmodulated_noz" mus-notch-unmodulated-noze) :double (ptr :pointer) (input :double))

(defcfun ("mus_all_pass" mus-all-pass) :double (gen :pointer) (input :double) (pm :double))
(defcfun ("mus_all_pass_unmodulated" mus-all-pass-unmodulated) :double (gen :pointer) (input :double))
(defcfun ("mus_make_all_pass" mus-make-all-pass) :pointer (backward :double) (forward :double) (size :int) (line (:pointer :double)) (line-size :int) (type :mus-interp))
(defcfun ("mus_all_pass_p" mus-all-pass-p) :boolean (ptr :pointer))
(defcfun ("mus_all_pass_unmodulated_noz" mus-all-pass-unmodulated-noz) :double (ptr :pointer) (input :double))

(defcfun ("mus_make_moving_average" mus-make-moving-average) :pointer (size :int) (line (:pointer :double)))
(defcfun ("mus_moving_average_p" mus-moving-average-p) :boolean (ptr :pointer))
(defcfun ("mus_moving_average" mus-moving-average) :double (ptr :pointer) (input :double))

(defcfun ("mus_table_lookup" mus-table-lookup) :double (gen :pointer) (fm :double))
(defcfun ("mus_table_lookup_unmodulated" mus-table-lookup-unmodulated) :double (gen :pointer))
(defcfun ("mus_make_table_lookup" mus-make-table-lookup) :pointer (freq :double) (phase :double) (wave (:pointer :double)) (wav-size :ullong) (type :mus-interp))
(defcfun ("mus_table_lookup_p" mus-table-lookup-p) :boolean (ptr :pointer))
(defcfun ("mus_partials_to_wave" mus-partials-to-wave) (:pointer :double) (partial-data (:pointer :double)) (partials :int) (table (:pointer :double)) (table-size :ullong) (normalize :boolean))
(defcfun ("mus_phase_partials_to_wave" mus-phase-partials-to-wave) (:pointer :double) (partial-data (:pointer :double)) (partials :int) (table (:pointer :double)) (table-size :ullong) (normalize :boolean))

(defcfun ("mus_sawtooth_wave" mus-sawtooth-wave) :double (gen :pointer) (fm :double))
(defcfun ("mus_make_sawtooth_wave" mus-make-sawtoth-wave) :pointer (freq :double) (phase :double))
(defcfun ("mus_sawtooth_wave_p" mus-sawtooth-wave-p) :boolean (gen :pointer))

(defcfun ("mus_square_wave" mus-square-wave) :double (gen :pointer) (fm :double))
(defcfun ("mus_make_square_wave" mus-make-square-wave) :pointer (freq :double) (amp :double) (phase :double))
(defcfun ("mus_square_wave_p" mus-square-wave-p) :boolean (gen :pointer))

(defcfun ("mus_triangle_wave" mus-triangle-wave) :double (gen :pointer) (fm :double))
(defcfun ("mus_make_triangle_wave" mus-make-triangle-wave) :pointer (freq :double) (amp :double) (phase :double))
(defcfun ("mus_triangle_wave_p" mus-triangle-wave-p) :boolean (ggen :pointer))

(defcfun ("mus_pulse_train" mus-pulse-train):double (gen :pointer) (fm :double))
(defcfun ("mus_make_pulse_train" mus-make-pulse-train) :pointer (freq :double) (amp :double) (phase :double))
(defcfun ("mus_pulse_train_p" mus-pulse-train-p) :boolean (gen :pointer))

(defcfun ("mus_set_rand_seed" mus-set-rand-seed) :void (seed :ulong))
(defcfun ("mus_rand_seed" mus-rand-seed) :ulong)
(defcfun ("mus_random" mus-random) :double (amp :double))
(defcfun ("mus_frandom" mus-frandom) :double (amp :double))
(defcfun ("mus_random_no_input" mus-random-no-input) :double)
(defcfun ("mus_frandom_no_input" mus-frandom-no-input) :double)
(defcfun ("mus_irandom" mus-irandom) :int (amp :int))

(defcfun ("mus_rand" mus-rand) :double (gen :pointer) (fm :double))
(defcfun ("mus_make_rand" mus-make-rand) :pointer (freq :double) (base :double))
(defcfun ("mus_rand_p" mus-rand-p) :boolean (ptr :pointer))
(defcfun ("mus_make_rand_with_distribution" mus-make-rand-with-distribution) :pointer (freq :double) (base :double) (distribution (:pointer :double)) (distribution-size :int))

(defcfun ("mus_rand_interp" mus-rand-interp) :double (gen :pointer) (fm :double))
(defcfun ("mus_make_rand_interp" mus-make-rand-interp) :pointer (freq :double) (base :double))
(defcfun ("mus_rand_interp_p" mus-rand-interp-p) :boolean (ptr :pointer))
(defcfun ("mus_make_rand_interp_with_distribution" mus-make-rand-interp-with-distribution) :pointer (freq :double) (base :double) (distribution (:pointer :double)) (distribution-size :int))
(defcfun ("mus_rand_interp_unmodulated" mus-rand-interp-unmodulated) :double (ptr :pointer))
(defcfun ("mus_rand_unmodulated" mus-rand-unmodulated) :double (ptr :pointer))

(defcfun ("mus_asymmetric_fm" mus-asymmetric-fm) :double (gen :pointer) (index :double) (fm :double))
(defcfun ("mus_asymmetric_fm_unmodulated" mus-asymmetric-fm-unmodulated) :double (gen :pointer) (index :double))
(defcfun ("mus_asymmetric_fm_no_input" mus-asymmetric-fm-no-input) :double (gen :pointer))
(defcfun ("mus_make_asymmetric_fm" mus-make-asymmetric-fm) :pointer (freq :double) (phase :double) (r :double) (ratio :double))
(defcfun ("mus_asymmetric_fm_p" mus-asymmetric-fm-p) :boolean (ptr :pointer))

(defcfun ("mus_one_zero" mus-one-zero) :double (gen :pointer) (input :double))
(defcfun ("mus_make_one_zero" mus-make-one-zer) :pointer (a0 :double) (a1 :double))
(defcfun ("mus_one_zero_p" mus-one-zero-p) :boolean (gen :pointer))

(defcfun ("mus_one_pole" mus-one-pole) :double (gen :pointer) (input :double))
(defcfun ("mus_make_one_pole" mus-make-one-pole) :pointer (a0 :double) (b1 :double))
(defcfun ("mus_one_pole_p" mus-one-pole-) :boolean (gen :pointer))

(defcfun ("mus_two_zero" mus-two-zero) :double (gen :pointer) (input :double))
(defcfun ("mus_make_two_zero" mus-make-two-zero) :pointer (a0 :double) (a1 :double) (a2 :double))
(defcfun ("mus_two_zero_p" mus-two-zero-p) :boolean (gen :pointer))
(defcfun ("mus_make_two_zero_from_frequency_and_radius" mus-make-two-zero-from-frequency-and-radius) :pointer (frequency :double) (radius :double))

(defcfun ("mus_two_pole" mus-two-pole) :double (gen :pointer) (input :double))
(defcfun ("mus_make_two_pole" mus-make-two-pole) :pointer (a0 :double) (b1 :double) (b2 :double))
(defcfun ("mus_two_pole_p" mus-two-pole-p) :boolean (gen :pointer))
(defcfun ("mus_make_two_pole_from_frequency_and_radius" mus-make-two-pole-from-frequency-and-radius) :pointer (frequency :double) (radius :double))

(defcfun ("mus_formant" mus-formant):double (ptr :pointer) (input :double))
(defcfun ("mus_make_formant" mus-make-formant) :pointer (frequency :double) (radius :double))
(defcfun ("mus_formant_p" mus-formant-p) :boolean (ptr :pointer))
(defcfun ("mus_set_formant_radius_and_frequency" mus-set-formant-radius-and-frequency) :void (ptr :pointer) (radius :double) (frequence :double))
(defcfun ("mus_formant_with_frequency" mus-formant-with-frequency) :double (ptr :pointer) (input :double) (freq-in-radians :double))
(defcfun ("mus_formant_bank" mus-formant-bank) :double (amps (:pointer :double)) (formants (:pointer :pointer)) (inval :double) (size :int))

(defcfun ("mus_firmant" mus-firmant) :double (ptr :pointer) (input :double))
(defcfun ("mus_make_firmant" mus-make-firmant) :pointer (frequence :double) (radius :double))
(defcfun ("mus_firmant_p" mus-firmant-p) :boolean (ptr :pointer))
(defcfun ("mus_firmant_with_frequency" mus-firmant-with-frequency) :double (ptr :pointer) (input :double) (freq-in-radians :double))

(defcfun ("mus_filter" mus-filter) :double (ptr :pointer) (input :double))
(defcfun ("mus_make_filter" mus-make-filter) :pointer (order :int) (xcoeffs (:pointer :double)) (ycoeffs (:pointer :double)) (state (:pointer :double)))
(defcfun ("mus_filter_p" mus-filter-p) :boolean (ptr :pointer))

(defcfun ("mus_fir_filter" mus-fir-filter) :double (ptr :pointer) (input :double))
(defcfun ("mus_make_fir_filter" mus-make-fir-filter) :pointer (order :int) (xcoeffs (:pointer :double)) (state (:pointer :double)))
(defcfun ("mus_fir_filter_p" mus-fir-filter-p) :boolean (ptr :pointer))

(defcfun ("mus_iir_filter" mus-iir-filter) :double (ptr :pointer) (input :double))
(defcfun ("mus_make_iir_filter" mus-make-iir-filter) :pointer (order :int) (ycoeffs (:pointer :double)) (state (:pointer :double)))
(defcfun ("mus_iir_filter_p" mus-iir-filter-p) :boolean (ptr :pointer))
(defcfun ("mus_make_fir_coeffs" mus-make-fir-coeffs) (:pointer :double) (order :int) (env (:pointer :double)) (aa (:pointer :double)))

(defcfun ("mus_filter_set_xcoeffs" mus-filter-set-xcoeffs) (:pointer :double) (ptr :pointer) (new-data (:pointer :double)))
(defcfun ("mus_filter_set_ycoeffs" mus-filter-set-ycoeffs) (:pointer :double) (ptr :pointer) (new-data (:pointer :double)))
(defcfun ("mus_filter_set_order" mus-filter-set-order) :int (ptr :pointer) (order :int))

(defcfun ("mus_filtered_comb" mus-filtered-comb) :double (ptr :pointer) (input :double) (pm :double))
(defcfun ("mus_filtered_comb_unmodulated" mus-filtered-comb-unmodulated) :double (ptr :pointer) (input :double))
(defcfun ("mus_filtered_comb_p" mus-filtered-comb-p) :boolean (ptr :pointer))
(defcfun ("mus_make_filtered_comb" mus-make-filtered-comb) :pointer (scaler :double) (size :int) (line (:pointer :double)) (line-size :int) (type :mus-interp) (filter :pointer #|mus_any|#))

(defcfun ("mus_wave_train" mus-wave-train) :double (gen :pointer) (fm :double))
(defcfun ("mus_wave_train_unmodulated" mus-wave-train-unmodulated) :double (gen :pointer))
(defcfun ("mus_make_wave_train" mus-make-wave-train) :pointer (freq :double) (phase :double) (wave (:pointer :double)) (wsize :ullong) (type :mus-interp))
(defcfun ("mus_wave_train_p" mus-wave-train-p) :boolean (gen :pointer))

(defcfun ("mus_partials_to_polynomial" mus-partials-to-polynomial) (:pointer :double) (npartials :int) (partials (:pointer :double)) (kind :mus-polynomial))
(defcfun ("mus_normalize_partials" mus-normalize-partials) (:pointer :double) (num-partials :int) (partials (:pointer :double)))

(defcfun ("mus_make_polyshape" mus-make-polyshape) :pointer (frequency :double) (phase :double) (coeffs (:pointer :double)) (size :int) (cheby-choice :int))
(defcfun ("mus_polyshape" mus-polyshape) :double (ptr :pointer) (index :double) (fm :double))
;;TODO
;#define mus_polyshape_fm(Obj, Fm) mus_polyshape(Obj, 1.0, Fm)
(defcfun ("mus_polyshape_unmodulated" mus-polyshape-unmodulated) :double (ptr :pointer) (index :double))
;;TODO
;#define mus_polyshape_no_input(Obj) mus_polyshape(Obj, 1.0, 0.0)
(defcfun ("mus_polyshape_p" mus-polyshape-p) :boolean (ptr :pointer))

(defcfun ("mus_make_polywave" mus-make-polywave) :pointer (frequency :double) (coeffs (:pointer :double)) (n :int) (cheby-choice :int))
(defcfun ("mus_polywave_p" mus-polywave-p) :boolean (ptr :pointer))
(defcfun ("mus_polywave_unmodulated" mus-polywave-unmodulated) :double (ptr :pointer))
(defcfun ("mus_polywave" mus-polywave) :double (ptr :pointer) (fm :double))
(defcfun ("mus_chebyshev_t_sum" mus-chebyshev-t-sum) :double (x :double) (n :int) (tn (:pointer :double)))
(defcfun ("mus_chebyshev_u_sum" mus-chebyshev-u-sum) :double (x :double) (n :int) (un (:pointer :double)))
(defcfun ("mus_chebyshev_tu_sum" mus-chebyshev-tu-sum) :double(x :double) (n :int)  (tn (:pointer :double)) (un (:pointer :double)))
;;TODO
;#define mus_polywave_type(Obj) mus_channel(Obj)

(defcfun ("mus_env" mus-env) :double (ptr :pointer))
(defcfun ("mus_make_env" mus-make-env) :pointer (brkpts (:pointer :double)) (npts :int) (scaler :double) (offset :double) (base :double) (duration :double) (end :ullong) (odata (:pointer :double)))
(defcfun ("mus_env_p" mus-env-p) :boolean (ptr :pointer))
(defcfun ("mus_env_interp" mus-env-interp) :double (x :double) (env :pointer #|mus_any|#))
(defcfun ("mus_env_passes" mus-env-passes) (:pointer :ullong) (gen :pointer)) ;for Snd
(defcfun ("mus_env_rates" mus-env-rates) (:pointer :double) (gen :pointer));        /* for Snd */
(defcfun ("mus_env_offset" mus-env-offset) :double (gen :pointer));        /* for Snd */
(defcfun ("mus_env_scaler" mus-env-scaler) :double (gen :pointer));        /* for Snd */
(defcfun ("mus_env_initial_power" mus-env-initial-power) :double (gen :pointer)); /* for Snd */
(defcfun ("mus_env_breakpoints" mus-env-breakpoints) :int (gen :pointer));      /* for Snd */
(defcfun ("mus_env_any" mus-env-any) :double (e :pointer) (connect-points (:pointer :double)) (val :double))
;TODO
;#define mus_make_env_with_length(Brkpts, Pts, Scaler, Offset, Base, Length) mus_make_env(Brkpts, Pts, Scaler, Offset, Base, 0.0, (Length) - 1, NULL)
(defcfun ("mus_env_linear" mus-env-linear) :double (ptr :pointer))
(defcfun ("mus_env_exponential" mus-env-exponential) :double (ptr :pointer))
(defcfun ("mus_env_step" mus-env-step) :double (ptr :pointer))
(defcfun ("mus_env_type" mus-env-type) :mus-env (ptr :pointer))

(defcfun ("mus_frame_p" mus-frame-p) :boolean (ptr :pointer))
(defcfun ("mus_make_empty_frame" mus-make-empty-frame) :pointer (chans :int))
;TODO
;(defcfun mus_any *mus_make_frame :pointer (int chans, ...);
(defcfun ("mus_frame_add" mus-frame-add) :pointer (f1 :pointer) (f2 :pointer) (res :pointer))
(defcfun ("mus_frame_multiply" mus-frame-multiply) :pointer (f1 :pointer) (f2 :pointer) (res :pointer))
(defcfun ("mus_frame_scale" mus-frame-scale) :pointer (uf1 :pointer) (sc1 :pointer) (ures :pointer))
(defcfun ("mus_frame_offset" mus-frame-offset) :pointer (uf1 :pointer) (offset :double) (ures :pointer))
(defcfun ("mus_frame_ref" mus-frame-ref) :double (f :pointer) (chan :int))
(defcfun ("mus_frame_set" mus-frame-set) :double (f :pointer) (chan :int) (val :double))
(defcfun ("mus_frame_copy" mus-frame-copy) :pointer (uf :pointer))
(defcfun ("mus_frame_fill" mus-frame-fill) :double (uf :pointer) (val :double))

(defcfun ("mus_mixer_p" mus-mixer-p) :boolean (ptr :pointer))
(defcfun ("mus_make_empty_mixer" mus-make-empty-mixer) :pointer (chans :int))
(defcfun ("mus_make_identity_mixer" mus-make-identity-mixer) :pointer (chans :int))
;(defcfun mus_any *mus_make_mixer(int chans, ...);
(defcfun ("mus_mixer_ref" mus-mixer-ref)  :double (f :pointer) (in :int) (out :int))
(defcfun ("mus_mixer_set" mus-mixer-set) :double (f :pointer) (in :int) (out :int) (val :double))
(defcfun ("mus_frame_to_frame" mus-frame-to-frame) :pointer (f :pointer) (ln :pointer) (out :pointer))
(defcfun ("mus_sample_to_frame" mus-sample-to-frame) :pointer (f :pointer) (in :double) (out :pointer))
(defcfun ("mus_frame_to_sample" mus-frame-to-sample) :double (f :pointer) (in :pointer))
(defcfun ("mus_mixer_multiply" mus-mixer-multiply) :pointer (f1 :pointer) (f2 :pointer) (res :pointer))
(defcfun ("mus_mixer_add" mus-mixer-add) :pointer (f1 :pointer) (f2 :pointer) (res :pointer))
(defcfun ("mus_mixer_scale" mus-mixer-scale) :pointer (uf1 :pointer) (scaler :double) (ures :pointer))
(defcfun ("mus_mixer_offset" mus-mixer-offset) :pointer (uf1 :pointer) (offset :double) (ures :pointer))
(defcfun ("mus_make_scalar_mixer" mus-make-scalar-mixer) :pointer (chans :int) (scalar :double))
(defcfun ("mus_mixer_copy" mus-mixer-copy) :pointer (uf :pointer))
(defcfun ("mus_mixer_fill" mus-mixer-fill) :double (uf :pointer) (val :double))

(defcfun ("mus_frame_to_frame_mono" mus-frame-to-frame-mono) :pointer (frame :pointer) (mix :pointer) (out :pointer))
(defcfun ("mus_frame_to_frame_stereo" mus-frame-to-stereo) :pointer (frame :pointer) (mix :pointer) (out :pointer))
(defcfun ("mus_frame_to_frame_mono_to_stereo" mus-frame-to-frame-mono-to-stereo) :pointer (frame :pointer) (mix :pointer) (out :pointer))

(defcfun ("mus_file_to_sample_p" mus-file-to-sample-p) :boolean (ptr :pointer))
(defcfun ("mus_make_file_to_sample" mus-make-file-to-sample) :pointer (filename :string))
(defcfun ("mus_make_file_to_sample_with_buffer_size" mus-make-file-to-sample-with-buffer-size) :pointer (filename :string) (buffer-size :ullong))
(defcfun ("mus_file_to_sample" mus-file-to-sample) :double (ptr :pointer) (samp :ullong) (chan :int))
(defcfun ("mus_in_any_from_file" mus-in-any-from-file) :double (ptr :pointer) (samp :ullong) (chna :int))

(defcfun ("mus_readin" mus-readin) :double (rd :pointer))
(defcfun ("mus_make_readin_with_buffer_size" mus-make-readin-with-buffer-size) :pointer (filename :string) (chan :int) (start :ullong) (direction :int) (buffer-size :ullong))
;;TODO
;#define mus_make_readin(Filename, Chan, Start, Direction) mus_make_readin_with_buffer_size(Filename, Chan, Start, Direction, mus_file_buffer_size())
(defcfun ("mus_readin_p" mus-readin-p) :boolean (ptr :pointer))

(defcfun ("mus_output_p" mus-output-p) :boolean (ptr :pointer))
(defcfun ("mus_input_p" mus-input-p) :boolean (ptr :pointer))
(defcfun ("mus_in_any" mus-in-any) :double (frame :ullong) (chan :int) (io :pointer))

(defcfun ("mus_make_file_to_frame" mus-make-file-to-frame) :pointer (filename :string))
(defcfun ("mus_file_to_frame_p" mus-file-to-frame-p) :boolean (ptr :pointer))
(defcfun ("mus_file_to_frame" mus-file-to-frame) :pointer (ptr :pointer) (samp :ullong) (f :pointer))
(defcfun ("mus_make_file_to_frame_with_buffer_size" mus-make-file-to-frame-with-buffer-size) :pointer (filename :string) (buffer-size :ullong))

(defcfun ("mus_sample_to_file_p" mus-sample-to-file-p) :boolean (ptr :pointer))
(defcfun ("mus_make_sample_to_file_with_comment" mus-make-sample-to-file-with-comment) :pointer (filename :string) (out-chans :int) (out-format :int) (out-type :int) (comment :string))
;TODO
;#define mus_make_sample_to_file(Filename, Chans, OutFormat, OutType) mus_make_sample_to_file_with_comment(Filename, Chans, OutFormat, OutType, NULL)
(defcfun ("mus_sample_to_file" mus-sample-to-file) :double (ptr :pointer) (samp :ullong) (chan :int) (val :double))
(defcfun ("mus_continue_sample_to_file" mus-continue-sample-to-file) :pointer (filename :string))
(defcfun ("mus_close_file" mus-close-file) :int (ptr :pointer))
(defcfun ("mus_sample_to_file_add" mus-sample-to-file-add) :pointer (out1 :pointer) (out2 :pointer))

(defcfun ("mus_out_any" mus-out-any) :double (frame :ullong) (val :double) (chna :int) (io :pointer))
(defcfun ("mus_out_any_to_file" mus-aout-any-to-file) :double (ptr :pointer) (samp :ullong) (chan :int) (val :double))
(defcfun ("mus_frame_to_file_p" mus-frame-to-file-p) :boolean (ptr :pointer))
(defcfun ("mus_frame_to_file" mus-frame-to-file) :pointer (ptr :pointer) (samp :ullong) (data :pointer))
(defcfun ("mus_make_frame_to_file_with_comment" mus-make-frame-to-file-with-comment) :pointer (filename :string) (chans :int) (out-format :int) (out-type :int) (comment :string))
;TODO
;#define mus_make_frame_to_file(Filename, Chans, OutFormat, OutType) mus_make_frame_to_file_with_comment(Filename, Chans, OutFormat, OutType, NULL)
(defcfun ("mus_continue_frame_to_file" mus-continue-frame-to-file) :pointer (filename :string))

(defcfun ("mus_locsig" mus-locsig) :void (ptr :pointer) (loc :ullong) (val :double))
(defcfun ("mus_make_locsig" mus-make-locsig) :pointer (degree :double) (distance :double) (reverb :double) (chans :int) (output :pointer) (rev-chans :int) (revput :pointer) (type :mus-interp))
(defcfun ("mus_locsig_p" mus-locsig-p) :boolean (ptr :pointer))
(defcfun ("mus_locsig_ref" mus-locsig-ref) :double (ptr :pointer) (chan :int))
(defcfun ("mus_locsig_set" mus-locsig-set) :double (ptr :pointer) (chan :int) (val :double))
(defcfun ("mus_locsig_reverb_ref" mus-locsig-reverb-ref) :double (ptr :pointer) (chan :int))
(defcfun ("mus_locsig_reverb_set" mus-locsig-reverb-set) :double (ptr :pointer) (chan :int) (val :double))
(defcfun ("mus_move_locsig" mus-move-locsig) :void (ptr :pointer) (degree :double) (distance :double))
(defcfun ("mus_locsig_outf" mus-locsig-outf) :pointer (ptr :pointer))
(defcfun ("mus_locsig_revf" mus-locsig-revf) :pointer (ptr :pointer))
(defcfun ("mus_locsig_closure" mus-locsig-closure):void (ptr :pointer))

(defcfun ("mus_move_sound_p" mus-move-sound-p) :boolean (ptr :pointer))
(defcfun ("mus_move_sound" mus-move-sound) :double (ptr :pointer) (loc :ullong) (val :double))
(defcfun ("mus_make_move_sound" mus-make-move-sound) :pointer 
  (start :ullong) (end :ullong) (out-channels :int) (rev-channels :int) (doppler-delay :pointer) 
  (doppler-env :pointer) (rev-env :pointer) (out-delays (:pointer :pointer)) (out-envs (:pointer :pointer))
  (rev-envs (:pointer :pointer)) (out-map :int) (output :pointer) (revput :pointer) (free-arrays :boolean)
  (free-gens :boolean))

(defcfun ("mus_move_sound_outf" mus-move-sound-outf) :pointer (ptr :pointer))
(defcfun ("mus_move_sound_revf" mus-move-sound-revf) :pointer (ptr :pointer))
(defcfun ("mus_move_sound_closure" mus-move-sound-closure) :void (ptr :pointer))

;TODO
;(defcfun mus_any *mus_make_src(mus_float_t (*input)(void *arg, int direction), mus_float_t srate, int width, void *closure);

;(defcfun mus_float_t mus_src :double (mus_any *srptr, mus_float_t sr_change, mus_float_t (*input)(void *arg, int direction));
;(defcfun bool mus_src_p :boolean (ptr :pointer);
;(defcfun mus_float_t mus_src_20 :double (mus_any *srptr, mus_float_t (*input)(void *arg, int direction));
;(defcfun mus_float_t mus_src_05 :double (mus_any *srptr, mus_float_t (*input)(void *arg, int direction));

;(defcfun bool mus_convolve_p(ptr :pointer);
;(defcfun mus_float_t mus_convolve(ptr :pointer, mus_float_t (*input)(void *arg, int direction));
;(defcfun mus_any *mus_make_convolve(mus_float_t (*input)(void *arg, int direction), mus_float_t *filter, mus_long_t fftsize, mus_long_t filtersize, void *closure);

(defcfun ("mus_spectrum" mus-spectrum) (:pointer :double) (rdat (:pointer :double)) (idat (:pointer :double)) (window (:pointer :double)) (n :ullong) (type :mus-spectrum-type))
(defcfun ("mus_fft" mus-fft) :void (r1 (:pointer :double)) (im (:pointer :double)) (n :ullong) (is :int))
(defcfun ("mus_make_fft_window" mus-make-fft-window) (:pointer :double) (type :mus-fft-window-type) (size :ullong) (beta :double))
(defcfun ("mus_make_fft_window_with_window" mus-make-fft-window-with-window) (:pointer :double) (type :mus-fft-window-type) (size :ullong) (beta :double) (mu :double) (window (:pointer :double)))
(defcfun ("mus_fft_window_name" mus-fft-window-name) :string (window :mus-fft-window-type))
(defcfun ("mus_fft_window_names" mus-fft-window-names) (:pointer :string))

(defcfun ("mus_autocorrelate" mus-autocorrelate) (:pointer :double) (data (:pointer :double)) (n :ullong))
(defcfun ("mus_correlate" mus-correlate) (:pointer :double) (data1 (:pointer :double)) (data2 (:pointer :double)) (n :ullong))
(defcfun ("mus_convolution" mus-convolution) (:pointer :double) (rl1 (:pointer :double)) (rl2 (:pointer :double)) (n :ullong))
(defcfun ("mus_convolve_files" mus-convolve-files) :void (file1 :string) (file2 :string) (maxamp :double) (output-file :string))
(defcfun ("mus_cepstrum" mus-cepstrum)(:pointer :double) (data (:pointer :double)) (n :ullong))

(defcfun ("mus_granulate_p" mus-granulate-p) :boolean (ptr :pointer))
;(defcfun ("mus_granulate" mus-granulate) :double (ptr :pointer) , mus_float_t (*input)(void *arg, int direction));
;(defcfun mus_float_t mus_granulate_with_editor :double (ptr :pointer, mus_float_t (*input)(void *arg, int direction), int (*edit)(void *closure));
;(defcfun mus_any *mus_make_granulate(mus_float_t (*input)(void *arg, int direction), 
;				       mus_float_t expansion, mus_float_t length, mus_float_t scaler, 
;				       mus_float_t hop, mus_float_t ramp, mus_float_t jitter, int max_size, 
;				       int (*edit)(void *closure),
;				       void *closure);
(defcfun ("mus_granulate_grain_max_length" mus-granulate-grain-max-length) :int (ptr :pointer))
;(defcfun ("mus_granulate_set_edit_function" mus-granulate-set-edit-function) :void (ptr :pointer) ,int (*edit)(void *closure));

(defcfun ("mus_set_file_buffer_size" mus-set-file-buffer-size) :ullong (size :ullong))
(defcfun ("mus_file_buffer_size" mus-file-buffer-size) :ullong)

(defcfun ("mus_mix" mus-mix) :void (outfile :string) (infile :string) (out-start :ullong) (out-samps :ullong) (in-start :ullong) (mx :pointer) (envs (:pointer (:pointer :pointer))))
(defcfun ("mus_mix_with_reader_and_writer" mus-mix-with-reader-and-writer) :void (outf :pointer) (inf :pointer) (out-start :ullong) (out-frames :ullong) (in-start :ullong) (umx :pointer) (envs (:pointer (:pointer :pointer))))
(defcfun ("mus_apply" mus-apply) :double (gen :pointer) (f1 :double) (f2 :double))

(defcfun ("mus_phase_vocoder_p" mus-phase-vocoder-p) :boolean (ptr :pointer))
;(defcfun mus_any *mus_make_phase_vocoder(mus_float_t (*input)(void *arg, int direction), 
;					   int fftsize, int overlap, int interp,
;					   mus_float_t pitch,
;					   bool (*analyze)(void *arg, mus_float_t (*input)(void *arg1, int direction)),
;					   int (*edit)(void *arg), /* return value is ignored (int return type is intended to be consistent with granulate) */
;					   mus_float_t (*synthesize)(void *arg), 
;					   void *closure);
;(defcfun mus_float_t mus_phase_vocoder(mus_any *ptr, mus_float_t (*input)(void *arg, int direction));
;(defcfun mus_float_t mus_phase_vocoder_with_editors(mus_any *ptr, 
;						mus_float_t (*input)(void *arg, int direction),
;						bool (*analyze)(void *arg, mus_float_t (*input)(void *arg1, int direction)),
;						int (*edit)(void *arg), 
;						mus_float_t (*synthesize)(void *arg));

(defcfun ("mus_phase_vocoder_amp_increments" mus-phase-vocoder-amp-increments) (:pointer :double) (ptr :pointer))
(defcfun ("mus_phase_vocoder_amps" mus-phase-vocoder-amps) (:pointer :double) (ptr :pointer))
(defcfun ("mus_phase_vocoder_freqs" mus-phase-vocoder-freqs) (:pointer :double) (ptr :pointer))
(defcfun ("mus_phase_vocoder_phases" mus-phase-vocoder-phases) (:pointer :double) (ptr :pointer))
(defcfun ("mus_phase_vocoder_phase_increments" mus-phase-vocoder-phase-increments) (:pointer :double) (ptr :pointer))

(defcfun ("mus_make_ssb_am" mus-make-ssb-am) :pointer (freq :double) (order :int))
(defcfun ("mus_ssb_am_p" mus-ssb-am-p) :boolean (ptr :pointer))
(defcfun ("mus_ssb_am_unmodulated" mus-ssb-am-unmodulated) :double (ptr :pointer) (insig :double))
(defcfun ("mus_ssb_am" mus-ssb-am) :double (ptr :pointer) (insig :double) (fm :double))

(defcfun ("mus_clear_sinc_tables" mus-clear-sinc-tables) :void)
(defcfun ("mus_environ" mus-environ) :pointer (gen :pointer))
(defcfun ("mus_set_environ" mus-set-environ) :pointer (gen :pointer) (e :pointer))

