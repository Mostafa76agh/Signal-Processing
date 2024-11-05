# MATLAB Machine Learning and Signal Processing Codebase

This repository contains simplified versions of MATLAB code for machine learning classification and signal processing, specifically designed for feature extraction and classification of audio and vibration data. The code is optimized for a more concise and understandable structure, while retaining core functionality.

## Files Overview

### 1. `feature_extraction_audio.m`

This script processes a set of audio files and extracts features using FFT (Fast Fourier Transform) and STFT (Short-Time Fourier Transform). The goal is to convert raw audio data into feature vectors suitable for machine learning. 

**Key Functions:**
- **FFT and STFT**: Converts audio signal segments into frequency-domain representations, normalized to facilitate classification.
- **Sliding Window**: Extracts overlapping segments of the audio to capture temporal features.
  
### 2. `feature_extraction_vibration.m`

This script is similar to `feature_extraction_audio.m` but is specialized for vibration data rather than audio. It reads accelerometer data from multiple files and applies FFT and STFT to create feature vectors from vibration signals along three axes (X, Y, Z).

**Key Functions:**
- **3-Axis Feature Extraction**: Extracts features for each vibration axis independently, enabling a multi-dimensional analysis of motor vibrations.
- **Normalization and Aggregation**: Normalizes frequency features to ensure consistency and then aggregates features from all axes.

### 3. `classification_models.m`

This file contains implementations of multiple machine learning models, including k-NN, SVM, Decision Tree, Naive Bayes, and Random Forest, for classifying motor conditions based on extracted features.

**Key Features:**
- **10-Fold Cross-Validation**: Implements k-fold cross-validation for reliable accuracy estimation.
- **Confusion Matrix and Accuracy Calculation**: Computes and displays confusion matrices and average accuracies for each model, providing insights into each model’s performance.
- **Modular Structure**: Uses helper functions to streamline cross-validation and predictions, allowing easy extension or modification for other classifiers.

## How It Works

1. **Data Preprocessing and Feature Extraction**: 
   - The `feature_extraction_audio.m` and `feature_extraction_vibration.m` scripts read and preprocess audio or vibration data files. 
   - Data is segmented using a sliding window approach, and frequency features are extracted with FFT and STFT methods, creating normalized feature vectors suitable for classification.

2. **Model Training and Evaluation**:
   - `classification_models.m` uses the extracted features to train various classifiers, evaluating each model using 10-fold cross-validation to estimate performance.
   - Confusion matrices and average accuracy scores provide a clear overview of each classifier's effectiveness.

## Simplified Versions

These files are simplified to focus on essential steps and exclude sensitive data paths, in-depth comments, and complex data-handling structures. Helper functions and loops are used to make the code more modular and to reduce repetition, allowing for easier understanding and customization.

## Usage

1. **Prepare the Data**: Ensure the necessary `.mat` files (`All_Resulte.mat` and `y_accel.mat`) are in the same directory, as they contain the preprocessed feature matrix and labels.

2. **Run Feature Extraction**: 
   - Use `feature_extraction_audio.m` or `feature_extraction_vibration.m` to extract features from raw data files and save them for classification.

3. **Train and Test Models**:
   - Execute `classification_models.m` to train each classifier and evaluate its performance. The script saves the trained k-NN model for future use.

## Notes
- The code is intended for demonstration and educational purposes. Users should adjust paths, parameters, and model configurations based on their specific datasets and requirements.
- Some advanced settings, data paths, and pre-processing details have been removed for simplicity.

---

This setup provides a streamlined workflow from feature extraction to model training, making it easy to adapt for other signal processing and machine learning applications in MATLAB.
