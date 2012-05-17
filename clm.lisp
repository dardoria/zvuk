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


(defcenum mus-interp
    :none :linear :sinusoidal :all-pass 
    :lagrange :bezier :hermite :num-interps)

;; typedef enum {MUS_ENV_LINEAR, MUS_ENV_EXPONENTIAL, MUS_ENV_STEP} mus_env_t;

;; typedef enum {MUS_RECTANGULAR_WINDOW, MUS_HANN_WINDOW, MUS_WELCH_WINDOW, MUS_PARZEN_WINDOW, MUS_BARTLETT_WINDOW,
;; 	      MUS_HAMMING_WINDOW, MUS_BLACKMAN2_WINDOW, MUS_BLACKMAN3_WINDOW, MUS_BLACKMAN4_WINDOW,
;; 	      MUS_EXPONENTIAL_WINDOW, MUS_RIEMANN_WINDOW, MUS_KAISER_WINDOW, MUS_CAUCHY_WINDOW, MUS_POISSON_WINDOW,
;; 	      MUS_GAUSSIAN_WINDOW, MUS_TUKEY_WINDOW, MUS_DOLPH_CHEBYSHEV_WINDOW, MUS_HANN_POISSON_WINDOW, 
;; 	      MUS_CONNES_WINDOW, MUS_SAMARAKI_WINDOW, MUS_ULTRASPHERICAL_WINDOW, 
;; 	      MUS_BARTLETT_HANN_WINDOW, MUS_BOHMAN_WINDOW, MUS_FLAT_TOP_WINDOW,
;; 	      MUS_BLACKMAN5_WINDOW, MUS_BLACKMAN6_WINDOW, MUS_BLACKMAN7_WINDOW, MUS_BLACKMAN8_WINDOW, MUS_BLACKMAN9_WINDOW, MUS_BLACKMAN10_WINDOW,
;; 	      MUS_RV2_WINDOW, MUS_RV3_WINDOW, MUS_RV4_WINDOW, MUS_MLT_SINE_WINDOW, MUS_PAPOULIS_WINDOW, MUS_DPSS_WINDOW, MUS_SINC_WINDOW,
;; 	      MUS_NUM_FFT_WINDOWS} mus_fft_window_t;

;; typedef enum {MUS_SPECTRUM_IN_DB, MUS_SPECTRUM_NORMALIZED, MUS_SPECTRUM_RAW} mus_spectrum_t;
;; typedef enum {MUS_CHEBYSHEV_EITHER_KIND, MUS_CHEBYSHEV_FIRST_KIND, MUS_CHEBYSHEV_SECOND_KIND} mus_polynomial_t;

;; #if defined(__GNUC__) && (!(defined(__cplusplus)))
;;   #define MUS_RUN(GEN, ARG_1, ARG_2) ({ mus_any *_clm_h_1 = (mus_any *)(GEN); \
;;                                        ((*((_clm_h_1->core)->run))(_clm_h_1, ARG_1, ARG_2)); })
;; #else
;;   #define MUS_RUN(GEN, ARG_1, ARG_2) ((*(((GEN)->core)->run))(GEN, ARG_1, ARG_2))
;; #endif
;; #define MUS_RUN_P(GEN) (((GEN)->core)->run)
;; #define MUS_MAX_CLM_SINC_WIDTH 65536
;; #define MUS_MAX_CLM_SRC 65536.0

;; #ifdef __cplusplus
;; extern "C" {
;; #endif

;; MUS_EXPORT void mus_initialize(void);

;; MUS_EXPORT int mus_make_class_tag(void);
;; MUS_EXPORT mus_float_t mus_radians_to_hz(mus_float_t radians);
;; MUS_EXPORT mus_float_t mus_hz_to_radians(mus_float_t hz);
;; MUS_EXPORT mus_float_t mus_degrees_to_radians(mus_float_t degrees);
;; MUS_EXPORT mus_float_t mus_radians_to_degrees(mus_float_t radians);
;; MUS_EXPORT mus_float_t mus_db_to_linear(mus_float_t x);
;; MUS_EXPORT mus_float_t mus_linear_to_db(mus_float_t x);

;; MUS_EXPORT mus_float_t mus_srate(void);
;; MUS_EXPORT mus_float_t mus_set_srate(mus_float_t val);
;; MUS_EXPORT mus_long_t mus_seconds_to_samples(mus_float_t secs);
;; MUS_EXPORT mus_float_t mus_samples_to_seconds(mus_long_t samps);
;; MUS_EXPORT int mus_array_print_length(void);
;; MUS_EXPORT int mus_set_array_print_length(int val);
;; MUS_EXPORT mus_float_t mus_float_equal_fudge_factor(void);
;; MUS_EXPORT mus_float_t mus_set_float_equal_fudge_factor(mus_float_t val);

;; MUS_EXPORT mus_float_t mus_ring_modulate(mus_float_t s1, mus_float_t s2);
;; MUS_EXPORT mus_float_t mus_amplitude_modulate(mus_float_t s1, mus_float_t s2, mus_float_t s3);
;; MUS_EXPORT mus_float_t mus_contrast_enhancement(mus_float_t sig, mus_float_t index);
;; MUS_EXPORT mus_float_t mus_dot_product(mus_float_t *data1, mus_float_t *data2, mus_long_t size);
;; #if HAVE_COMPLEX_TRIG
;; MUS_EXPORT complex double mus_edot_product(complex double freq, complex double *data, mus_long_t size);
;; #endif

;; MUS_EXPORT void mus_clear_array(mus_float_t *arr, mus_long_t size);
;; MUS_EXPORT bool mus_arrays_are_equal(mus_float_t *arr1, mus_float_t *arr2, mus_float_t fudge, mus_long_t len);
;; MUS_EXPORT mus_float_t mus_polynomial(mus_float_t *coeffs, mus_float_t x, int ncoeffs);
;; MUS_EXPORT void mus_multiply_arrays(mus_float_t *data, mus_float_t *window, mus_long_t len);
;; MUS_EXPORT void mus_rectangular_to_polar(mus_float_t *rl, mus_float_t *im, mus_long_t size);
;; MUS_EXPORT void mus_rectangular_to_magnitudes(mus_float_t *rl, mus_float_t *im, mus_long_t size);
;; MUS_EXPORT void mus_polar_to_rectangular(mus_float_t *rl, mus_float_t *im, mus_long_t size);
;; MUS_EXPORT mus_float_t mus_array_interp(mus_float_t *wave, mus_float_t phase, mus_long_t size);
;; MUS_EXPORT double mus_bessi0(mus_float_t x);
;; MUS_EXPORT mus_float_t mus_interpolate(mus_interp_t type, mus_float_t x, mus_float_t *table, mus_long_t table_size, mus_float_t y);
;; MUS_EXPORT bool mus_interp_type_p(int val);
;; MUS_EXPORT bool mus_fft_window_p(int val);

;; MUS_EXPORT int mus_data_format_zero(int format);


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
(defcfun ("mus_make_delay" mus-make-delay) :pointer (size :int) (line (:pointer :double)) (line-size :int) (type mus-interp))
(defcfun ("mus_delay_p" mus-delay-p) :boolean (ptr :pointer))
(defcfun ("mus_delay_line_p" mus-delay-line-p) :boolean (gen :pointer))
(defcfun ("mus_delay_tick" mus-delay-tick) :double (ptr :pointer) (input :double))
(defcfun ("mus_delay_tick_noz" mus-delay-tick-noz) :double (ptr :pointer) (input :double))
(defcfun ("mus_delay_unmodulated_noz" mus-delay-unmodulated-noz) :double (ptr :pointer) (input :double))

(defcfun ("mus_comb" mus-comb) :double (gen :pointer) (input :double) (pm :double))
(defcfun ("mus_comb_unmodulated" mus-comb-unmodulated) :double (gen :pointer) (input :double))
(defcfun ("mus_make_comb" mus-make-comb) :pointer (scaler :double) (size :int) (line (:pointer :double)) (line-size :int) (type mus-interp))
(defcfun ("mus_comb_p" mus-comb-p) :boolean (ptr :pointer))
(defcfun ("mus_comb_unmodulated_noz" mus-comb-unmodulated-noz) :double (ptr :pointer) (input :double))

(defcfun ("mus_notch" mus-notch) :double (gen :pointer) (input :double) (pm :double))
(defcfun ("mus_notch_unmodulated" mus-notch-unmodulated) :double (gen :pointer) (input :double))
(defcfun ("mus_make_notch" mus-make-notch) :pointer (scaler :double) (size :int) (line :pointer :double) (line-size :int) (type mus-interp))
(defcfun ("mus_notch_p" mus-notch-p) :boolean (ptr :pointer))
(defcfun ("mus_notch_unmodulated_noz" mus-notch-unmodulated-noze) :double (ptr :pointer) (input :double))

(defcfun ("mus_all_pass" mus-all-pass) :double (gen :pointer) (input :double) (pm :double))
(defcfun ("mus_all_pass_unmodulated" mus-all-pass-unmodulated) :double (gen :pointer) (input :double))
(defcfun ("mus_make_all_pass" mus-make-all-pass) :pointer (backward :double) (forward :double) (size :int) (line (:pointer :double)) (line-size :int) (type mus-interp))
(defcfun ("mus_all_pass_p" mus-all-pass-p) :boolean (ptr :pointer))
(defcfun ("mus_all_pass_unmodulated_noz" mus-all-pass-unmodulated-noz) :double (ptr :pointer) (input :double))

(defcfun ("mus_make_moving_average" mus-make-moving-average) :pointer (size :int) (line (:pointer :double)))
(defcfun ("mus_moving_average_p" mus-moving-average-p) :boolean (ptr :pointer))
(defcfun ("mus_moving_average" mus-moving-average) :double (ptr :pointer) (input :double))

(defcfun ("mus_table_lookup" mus-table-lookup) :double (gen :pointer) (fm :double))
(defcfun ("mus_table_lookup_unmodulated" mus-table-lookup-unmodulated) :double (gen :pointer))
(defcfun ("mus_make_table_lookup" mus-make-table-lookup) :pointer (freq :double) (phase :double) (wave (:pointer :double)) (wav-size :ullong) (type mus-interp))
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
(defcfun ("mus_rand_interp_p" mus-rand-interp-p) :boolean (ptr :pointer);
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

;; MUS_EXPORT mus_float_t mus_firmant(mus_any *ptr, mus_float_t input);
;; MUS_EXPORT mus_any *mus_make_firmant(mus_float_t frequency, mus_float_t radius);
;; MUS_EXPORT bool mus_firmant_p(mus_any *ptr);
;; MUS_EXPORT mus_float_t mus_firmant_with_frequency(mus_any *ptr, mus_float_t input, mus_float_t freq_in_radians);

;; MUS_EXPORT mus_float_t mus_filter(mus_any *ptr, mus_float_t input);
;; MUS_EXPORT mus_any *mus_make_filter(int order, mus_float_t *xcoeffs, mus_float_t *ycoeffs, mus_float_t *state);
;; MUS_EXPORT bool mus_filter_p(mus_any *ptr);

;; MUS_EXPORT mus_float_t mus_fir_filter(mus_any *ptr, mus_float_t input);
;; MUS_EXPORT mus_any *mus_make_fir_filter(int order, mus_float_t *xcoeffs, mus_float_t *state);
;; MUS_EXPORT bool mus_fir_filter_p(mus_any *ptr);

;; MUS_EXPORT mus_float_t mus_iir_filter(mus_any *ptr, mus_float_t input);
;; MUS_EXPORT mus_any *mus_make_iir_filter(int order, mus_float_t *ycoeffs, mus_float_t *state);
;; MUS_EXPORT bool mus_iir_filter_p(mus_any *ptr);
;; MUS_EXPORT mus_float_t *mus_make_fir_coeffs(int order, mus_float_t *env, mus_float_t *aa);

;; MUS_EXPORT mus_float_t *mus_filter_set_xcoeffs(mus_any *ptr, mus_float_t *new_data);
;; MUS_EXPORT mus_float_t *mus_filter_set_ycoeffs(mus_any *ptr, mus_float_t *new_data);
;; MUS_EXPORT int mus_filter_set_order(mus_any *ptr, int order);

;; MUS_EXPORT mus_float_t mus_filtered_comb(mus_any *ptr, mus_float_t input, mus_float_t pm);
;; MUS_EXPORT mus_float_t mus_filtered_comb_unmodulated(mus_any *ptr, mus_float_t input);
;; MUS_EXPORT bool mus_filtered_comb_p(mus_any *ptr);
;; MUS_EXPORT mus_any *mus_make_filtered_comb(mus_float_t scaler, int size, mus_float_t *line, int line_size, mus_interp_t type, mus_any *filt);

;; MUS_EXPORT mus_float_t mus_wave_train(mus_any *gen, mus_float_t fm);
;; MUS_EXPORT mus_float_t mus_wave_train_unmodulated(mus_any *gen);
;; MUS_EXPORT mus_any *mus_make_wave_train(mus_float_t freq, mus_float_t phase, mus_float_t *wave, mus_long_t wsize, mus_interp_t type);
;; MUS_EXPORT bool mus_wave_train_p(mus_any *gen);

;; MUS_EXPORT mus_float_t *mus_partials_to_polynomial(int npartials, mus_float_t *partials, mus_polynomial_t kind);
;; MUS_EXPORT mus_float_t *mus_normalize_partials(int num_partials, mus_float_t *partials);

;; MUS_EXPORT mus_any *mus_make_polyshape(mus_float_t frequency, mus_float_t phase, mus_float_t *coeffs, int size, int cheby_choice);
;; MUS_EXPORT mus_float_t mus_polyshape(mus_any *ptr, mus_float_t index, mus_float_t fm);
;; #define mus_polyshape_fm(Obj, Fm) mus_polyshape(Obj, 1.0, Fm)
;; MUS_EXPORT mus_float_t mus_polyshape_unmodulated(mus_any *ptr, mus_float_t index);
;; #define mus_polyshape_no_input(Obj) mus_polyshape(Obj, 1.0, 0.0)
;; MUS_EXPORT bool mus_polyshape_p(mus_any *ptr);

;; MUS_EXPORT mus_any *mus_make_polywave(mus_float_t frequency, mus_float_t *coeffs, int n, int cheby_choice);
;; MUS_EXPORT bool mus_polywave_p(mus_any *ptr);
;; MUS_EXPORT mus_float_t mus_polywave_unmodulated(mus_any *ptr);
;; MUS_EXPORT mus_float_t mus_polywave(mus_any *ptr, mus_float_t fm);
;; MUS_EXPORT mus_float_t mus_chebyshev_t_sum(mus_float_t x, int n, mus_float_t *tn);
;; MUS_EXPORT mus_float_t mus_chebyshev_u_sum(mus_float_t x, int n, mus_float_t *un);
;; MUS_EXPORT mus_float_t mus_chebyshev_tu_sum(mus_float_t x, int n, mus_float_t *tn, mus_float_t *un);
;; #define mus_polywave_type(Obj) mus_channel(Obj)

;; MUS_EXPORT mus_float_t mus_env(mus_any *ptr);
;; MUS_EXPORT mus_any *mus_make_env(mus_float_t *brkpts, int npts, double scaler, double offset, double base, double duration, mus_long_t end, mus_float_t *odata);
;; MUS_EXPORT bool mus_env_p(mus_any *ptr);
;; MUS_EXPORT double mus_env_interp(double x, mus_any *env);
;; MUS_EXPORT mus_long_t *mus_env_passes(mus_any *gen);        /* for Snd */
;; MUS_EXPORT double *mus_env_rates(mus_any *gen);        /* for Snd */
;; MUS_EXPORT double mus_env_offset(mus_any *gen);        /* for Snd */
;; MUS_EXPORT double mus_env_scaler(mus_any *gen);        /* for Snd */
;; MUS_EXPORT double mus_env_initial_power(mus_any *gen); /* for Snd */
;; MUS_EXPORT int mus_env_breakpoints(mus_any *gen);      /* for Snd */
;; MUS_EXPORT mus_float_t mus_env_any(mus_any *e, mus_float_t (*connect_points)(mus_float_t val));
;; #define mus_make_env_with_length(Brkpts, Pts, Scaler, Offset, Base, Length) mus_make_env(Brkpts, Pts, Scaler, Offset, Base, 0.0, (Length) - 1, NULL)
;; MUS_EXPORT mus_float_t mus_env_linear(mus_any *ptr);
;; MUS_EXPORT mus_float_t mus_env_exponential(mus_any *ptr);
;; MUS_EXPORT mus_float_t mus_env_step(mus_any *ptr);
;; MUS_EXPORT mus_env_t mus_env_type(mus_any *ptr);

;; MUS_EXPORT bool mus_frame_p(mus_any *ptr);
;; MUS_EXPORT mus_any *mus_make_empty_frame(int chans);
;; MUS_EXPORT mus_any *mus_make_frame(int chans, ...);
;; MUS_EXPORT mus_any *mus_frame_add(mus_any *f1, mus_any *f2, mus_any *res);
;; MUS_EXPORT mus_any *mus_frame_multiply(mus_any *f1, mus_any *f2, mus_any *res);
;; MUS_EXPORT mus_any *mus_frame_scale(mus_any *uf1, mus_float_t scl, mus_any *ures);
;; MUS_EXPORT mus_any *mus_frame_offset(mus_any *uf1, mus_float_t offset, mus_any *ures);
;; MUS_EXPORT mus_float_t mus_frame_ref(mus_any *f, int chan);
;; MUS_EXPORT mus_float_t mus_frame_set(mus_any *f, int chan, mus_float_t val);
;; MUS_EXPORT mus_any *mus_frame_copy(mus_any *uf);
;; MUS_EXPORT mus_float_t mus_frame_fill(mus_any *uf, mus_float_t val);

;; MUS_EXPORT bool mus_mixer_p(mus_any *ptr);
;; MUS_EXPORT mus_any *mus_make_empty_mixer(int chans);
;; MUS_EXPORT mus_any *mus_make_identity_mixer(int chans);
;; MUS_EXPORT mus_any *mus_make_mixer(int chans, ...);
;; MUS_EXPORT mus_float_t mus_mixer_ref(mus_any *f, int in, int out);
;; MUS_EXPORT mus_float_t mus_mixer_set(mus_any *f, int in, int out, mus_float_t val);
;; MUS_EXPORT mus_any *mus_frame_to_frame(mus_any *f, mus_any *in, mus_any *out);
;; MUS_EXPORT mus_any *mus_sample_to_frame(mus_any *f, mus_float_t in, mus_any *out);
;; MUS_EXPORT mus_float_t mus_frame_to_sample(mus_any *f, mus_any *in);
;; MUS_EXPORT mus_any *mus_mixer_multiply(mus_any *f1, mus_any *f2, mus_any *res);
;; MUS_EXPORT mus_any *mus_mixer_add(mus_any *f1, mus_any *f2, mus_any *res);
;; MUS_EXPORT mus_any *mus_mixer_scale(mus_any *uf1, mus_float_t scaler, mus_any *ures);
;; MUS_EXPORT mus_any *mus_mixer_offset(mus_any *uf1, mus_float_t offset, mus_any *ures);
;; MUS_EXPORT mus_any *mus_make_scalar_mixer(int chans, mus_float_t scalar);
;; MUS_EXPORT mus_any *mus_mixer_copy(mus_any *uf);
;; MUS_EXPORT mus_float_t mus_mixer_fill(mus_any *uf, mus_float_t val);

;; MUS_EXPORT mus_any *mus_frame_to_frame_mono(mus_any *frame, mus_any *mix, mus_any *out);
;; MUS_EXPORT mus_any *mus_frame_to_frame_stereo(mus_any *frame, mus_any *mix, mus_any *out);
;; MUS_EXPORT mus_any *mus_frame_to_frame_mono_to_stereo(mus_any *frame, mus_any *mix, mus_any *out);

;; MUS_EXPORT bool mus_file_to_sample_p(mus_any *ptr);
;; MUS_EXPORT mus_any *mus_make_file_to_sample(const char *filename);
;; MUS_EXPORT mus_any *mus_make_file_to_sample_with_buffer_size(const char *filename, mus_long_t buffer_size);
;; MUS_EXPORT mus_float_t mus_file_to_sample(mus_any *ptr, mus_long_t samp, int chan);
;; MUS_EXPORT mus_float_t mus_in_any_from_file(mus_any *ptr, mus_long_t samp, int chan);

;; MUS_EXPORT mus_float_t mus_readin(mus_any *rd);
;; MUS_EXPORT mus_any *mus_make_readin_with_buffer_size(const char *filename, int chan, mus_long_t start, int direction, mus_long_t buffer_size);
;; #define mus_make_readin(Filename, Chan, Start, Direction) mus_make_readin_with_buffer_size(Filename, Chan, Start, Direction, mus_file_buffer_size())
;; MUS_EXPORT bool mus_readin_p(mus_any *ptr);

;; MUS_EXPORT bool mus_output_p(mus_any *ptr);
;; MUS_EXPORT bool mus_input_p(mus_any *ptr);
;; MUS_EXPORT mus_float_t mus_in_any(mus_long_t frame, int chan, mus_any *IO);

;; MUS_EXPORT mus_any *mus_make_file_to_frame(const char *filename);
;; MUS_EXPORT bool mus_file_to_frame_p(mus_any *ptr);
;; MUS_EXPORT mus_any *mus_file_to_frame(mus_any *ptr, mus_long_t samp, mus_any *f);
;; MUS_EXPORT mus_any *mus_make_file_to_frame_with_buffer_size(const char *filename, mus_long_t buffer_size);

;; MUS_EXPORT bool mus_sample_to_file_p(mus_any *ptr);
;; MUS_EXPORT mus_any *mus_make_sample_to_file_with_comment(const char *filename, int out_chans, int out_format, int out_type, const char *comment);
;; #define mus_make_sample_to_file(Filename, Chans, OutFormat, OutType) mus_make_sample_to_file_with_comment(Filename, Chans, OutFormat, OutType, NULL)
;; MUS_EXPORT mus_float_t mus_sample_to_file(mus_any *ptr, mus_long_t samp, int chan, mus_float_t val);
;; MUS_EXPORT mus_any *mus_continue_sample_to_file(const char *filename);
;; MUS_EXPORT int mus_close_file(mus_any *ptr);
;; MUS_EXPORT mus_any *mus_sample_to_file_add(mus_any *out1, mus_any *out2);

;; MUS_EXPORT mus_float_t mus_out_any(mus_long_t frame, mus_float_t val, int chan, mus_any *IO);
;; MUS_EXPORT mus_float_t mus_out_any_to_file(mus_any *ptr, mus_long_t samp, int chan, mus_float_t val);
;; MUS_EXPORT bool mus_frame_to_file_p(mus_any *ptr);
;; MUS_EXPORT mus_any *mus_frame_to_file(mus_any *ptr, mus_long_t samp, mus_any *data);
;; MUS_EXPORT mus_any *mus_make_frame_to_file_with_comment(const char *filename, int chans, int out_format, int out_type, const char *comment);
;; #define mus_make_frame_to_file(Filename, Chans, OutFormat, OutType) mus_make_frame_to_file_with_comment(Filename, Chans, OutFormat, OutType, NULL)
;; MUS_EXPORT mus_any *mus_continue_frame_to_file(const char *filename);

;; MUS_EXPORT void mus_locsig(mus_any *ptr, mus_long_t loc, mus_float_t val);
;; MUS_EXPORT mus_any *mus_make_locsig(mus_float_t degree, mus_float_t distance, mus_float_t reverb, int chans, mus_any *output, int rev_chans, mus_any *revput, mus_interp_t type);
;; MUS_EXPORT bool mus_locsig_p(mus_any *ptr);
;; MUS_EXPORT mus_float_t mus_locsig_ref(mus_any *ptr, int chan);
;; MUS_EXPORT mus_float_t mus_locsig_set(mus_any *ptr, int chan, mus_float_t val);
;; MUS_EXPORT mus_float_t mus_locsig_reverb_ref(mus_any *ptr, int chan);
;; MUS_EXPORT mus_float_t mus_locsig_reverb_set(mus_any *ptr, int chan, mus_float_t val);
;; MUS_EXPORT void mus_move_locsig(mus_any *ptr, mus_float_t degree, mus_float_t distance);
;; MUS_EXPORT mus_any *mus_locsig_outf(mus_any *ptr);
;; MUS_EXPORT mus_any *mus_locsig_revf(mus_any *ptr);
;; MUS_EXPORT void *mus_locsig_closure(mus_any *ptr);

;;   /* these are for the optimizer (run.c) */
;; MUS_EXPORT void mus_locsig_mono_no_reverb(mus_any *ptr, mus_long_t loc, mus_float_t val);
;; MUS_EXPORT void mus_locsig_mono(mus_any *ptr, mus_long_t loc, mus_float_t val);
;; MUS_EXPORT void mus_locsig_stereo_no_reverb(mus_any *ptr, mus_long_t loc, mus_float_t val);
;; MUS_EXPORT void mus_locsig_stereo(mus_any *ptr, mus_long_t loc, mus_float_t val);
;; MUS_EXPORT void mus_locsig_safe_mono_no_reverb(mus_any *ptr, mus_long_t loc, mus_float_t val);
;; MUS_EXPORT void mus_locsig_safe_mono(mus_any *ptr, mus_long_t loc, mus_float_t val);
;; MUS_EXPORT void mus_locsig_safe_stereo_no_reverb(mus_any *ptr, mus_long_t loc, mus_float_t val);
;; MUS_EXPORT void mus_locsig_safe_stereo(mus_any *ptr, mus_long_t loc, mus_float_t val);
;; MUS_EXPORT int mus_locsig_channels(mus_any *ptr);
;; MUS_EXPORT int mus_locsig_reverb_channels(mus_any *ptr);
;; MUS_EXPORT int mus_locsig_safety(mus_any *ptr);
;; MUS_EXPORT void mus_locsig_function_reset(mus_any *ptr);

;; MUS_EXPORT bool mus_move_sound_p(mus_any *ptr);
;; MUS_EXPORT mus_float_t mus_move_sound(mus_any *ptr, mus_long_t loc, mus_float_t val);
;; MUS_EXPORT mus_any *mus_make_move_sound(mus_long_t start, mus_long_t end, int out_channels, int rev_channels,
;; 					mus_any *doppler_delay, mus_any *doppler_env, mus_any *rev_env,
;; 					mus_any **out_delays, mus_any **out_envs, mus_any **rev_envs,
;; 					int *out_map, mus_any *output, mus_any *revput, bool free_arrays, bool free_gens);
;; MUS_EXPORT mus_any *mus_move_sound_outf(mus_any *ptr);
;; MUS_EXPORT mus_any *mus_move_sound_revf(mus_any *ptr);
;; MUS_EXPORT void *mus_move_sound_closure(mus_any *ptr);

;; MUS_EXPORT mus_any *mus_make_src(mus_float_t (*input)(void *arg, int direction), mus_float_t srate, int width, void *closure);
;; MUS_EXPORT mus_float_t mus_src(mus_any *srptr, mus_float_t sr_change, mus_float_t (*input)(void *arg, int direction));
;; MUS_EXPORT bool mus_src_p(mus_any *ptr);
;; MUS_EXPORT mus_float_t mus_src_20(mus_any *srptr, mus_float_t (*input)(void *arg, int direction));
;; MUS_EXPORT mus_float_t mus_src_05(mus_any *srptr, mus_float_t (*input)(void *arg, int direction));

;; MUS_EXPORT bool mus_convolve_p(mus_any *ptr);
;; MUS_EXPORT mus_float_t mus_convolve(mus_any *ptr, mus_float_t (*input)(void *arg, int direction));
;; MUS_EXPORT mus_any *mus_make_convolve(mus_float_t (*input)(void *arg, int direction), mus_float_t *filter, mus_long_t fftsize, mus_long_t filtersize, void *closure);

;; MUS_EXPORT mus_float_t *mus_spectrum(mus_float_t *rdat, mus_float_t *idat, mus_float_t *window, mus_long_t n, mus_spectrum_t type);
;; MUS_EXPORT void mus_fft(mus_float_t *rl, mus_float_t *im, mus_long_t n, int is);
;; MUS_EXPORT mus_float_t *mus_make_fft_window(mus_fft_window_t type, mus_long_t size, mus_float_t beta);
;; MUS_EXPORT mus_float_t *mus_make_fft_window_with_window(mus_fft_window_t type, mus_long_t size, mus_float_t beta, mus_float_t mu, mus_float_t *window);
;; MUS_EXPORT const char *mus_fft_window_name(mus_fft_window_t win);
;; MUS_EXPORT const char **mus_fft_window_names(void);

;; MUS_EXPORT mus_float_t *mus_autocorrelate(mus_float_t *data, mus_long_t n);
;; MUS_EXPORT mus_float_t *mus_correlate(mus_float_t *data1, mus_float_t *data2, mus_long_t n);
;; MUS_EXPORT mus_float_t *mus_convolution(mus_float_t *rl1, mus_float_t *rl2, mus_long_t n);
;; MUS_EXPORT void mus_convolve_files(const char *file1, const char *file2, mus_float_t maxamp, const char *output_file);
;; MUS_EXPORT mus_float_t *mus_cepstrum(mus_float_t *data, mus_long_t n);

;; MUS_EXPORT bool mus_granulate_p(mus_any *ptr);
;; MUS_EXPORT mus_float_t mus_granulate(mus_any *ptr, mus_float_t (*input)(void *arg, int direction));
;; MUS_EXPORT mus_float_t mus_granulate_with_editor(mus_any *ptr, mus_float_t (*input)(void *arg, int direction), int (*edit)(void *closure));
;; MUS_EXPORT mus_any *mus_make_granulate(mus_float_t (*input)(void *arg, int direction), 
;; 				       mus_float_t expansion, mus_float_t length, mus_float_t scaler, 
;; 				       mus_float_t hop, mus_float_t ramp, mus_float_t jitter, int max_size, 
;; 				       int (*edit)(void *closure),
;; 				       void *closure);
;; MUS_EXPORT int mus_granulate_grain_max_length(mus_any *ptr);
;; MUS_EXPORT void mus_granulate_set_edit_function(mus_any *ptr, int (*edit)(void *closure));

;; MUS_EXPORT mus_long_t mus_set_file_buffer_size(mus_long_t size);
;; MUS_EXPORT mus_long_t mus_file_buffer_size(void);

;; MUS_EXPORT void mus_mix(const char *outfile, const char *infile, mus_long_t out_start, mus_long_t out_samps, mus_long_t in_start, mus_any *mx, mus_any ***envs);
;; MUS_EXPORT void mus_mix_with_reader_and_writer(mus_any *outf, mus_any *inf, mus_long_t out_start, mus_long_t out_frames, mus_long_t in_start, mus_any *umx, mus_any ***envs);
;; MUS_EXPORT mus_float_t mus_apply(mus_any *gen, mus_float_t f1, mus_float_t f2);

;; MUS_EXPORT bool mus_phase_vocoder_p(mus_any *ptr);
;; MUS_EXPORT mus_any *mus_make_phase_vocoder(mus_float_t (*input)(void *arg, int direction), 
;; 					   int fftsize, int overlap, int interp,
;; 					   mus_float_t pitch,
;; 					   bool (*analyze)(void *arg, mus_float_t (*input)(void *arg1, int direction)),
;; 					   int (*edit)(void *arg), /* return value is ignored (int return type is intended to be consistent with granulate) */
;; 					   mus_float_t (*synthesize)(void *arg), 
;; 					   void *closure);
;; MUS_EXPORT mus_float_t mus_phase_vocoder(mus_any *ptr, mus_float_t (*input)(void *arg, int direction));
;; MUS_EXPORT mus_float_t mus_phase_vocoder_with_editors(mus_any *ptr, 
;; 						mus_float_t (*input)(void *arg, int direction),
;; 						bool (*analyze)(void *arg, mus_float_t (*input)(void *arg1, int direction)),
;; 						int (*edit)(void *arg), 
;; 						mus_float_t (*synthesize)(void *arg));

;; MUS_EXPORT mus_float_t *mus_phase_vocoder_amp_increments(mus_any *ptr);
;; MUS_EXPORT mus_float_t *mus_phase_vocoder_amps(mus_any *ptr);
;; MUS_EXPORT mus_float_t *mus_phase_vocoder_freqs(mus_any *ptr);
;; MUS_EXPORT mus_float_t *mus_phase_vocoder_phases(mus_any *ptr);
;; MUS_EXPORT mus_float_t *mus_phase_vocoder_phase_increments(mus_any *ptr);


;; MUS_EXPORT mus_any *mus_make_ssb_am(mus_float_t freq, int order);
;; MUS_EXPORT bool mus_ssb_am_p(mus_any *ptr);
;; MUS_EXPORT mus_float_t mus_ssb_am_unmodulated(mus_any *ptr, mus_float_t insig);
;; MUS_EXPORT mus_float_t mus_ssb_am(mus_any *ptr, mus_float_t insig, mus_float_t fm);

;; MUS_EXPORT void mus_clear_sinc_tables(void);
;; MUS_EXPORT void *mus_environ(mus_any *gen);
;; MUS_EXPORT void *mus_set_environ(mus_any *gen, void *e);


;; /* used only in run.lisp */
;; MUS_EXPORT mus_any *mus_make_frame_with_data(int chans, mus_float_t *data);
;; MUS_EXPORT mus_any *mus_make_mixer_with_data(int chans, mus_float_t *data);

;; #ifdef __cplusplus
;; }
;; #endif

;; #endif
