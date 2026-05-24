import numpy as np
import librosa
import joblib
import soundfile as sf

# ----------------------------
# FUNCTION: Predict new audio
# ----------------------------

def mp3_to_wav(filepath, sample_rate=22050):
    audio, sr= librosa.load(filepath, sr=sample_rate)
    output_path=filepath
    output_path.replace("mp3", "wav")
    sf.write(output_path, audio, sr)
    return output_path

def predict_audio(file_path):
    # Load trained model
    model = joblib.load(r"C:\Users\marya\PycharmProjects\animal\myapp\static\audio_datasetnew\aud_emo_model.pkl")
    if ".mp3" in file_path:
        file_path=mp3_to_wav(file_path)

    # Load the audio file
    signal, sr = librosa.load(file_path, mono=True)

    # Extract features (same as training)
    chroma_stft = librosa.feature.chroma_stft(y=signal, sr=sr)
    spec_centroid = librosa.feature.spectral_centroid(y=signal, sr=sr)
    spec_bandwidth = librosa.feature.spectral_bandwidth(y=signal, sr=sr)
    rolloff = librosa.feature.spectral_rolloff(y=signal, sr=sr)
    zero_crossing = librosa.feature.zero_crossing_rate(y=signal)
    mfcc = librosa.feature.mfcc(y=signal, sr=sr)

    # Store feature means
    features = [
        np.mean(chroma_stft),
        np.mean(spec_centroid),
        np.mean(spec_bandwidth),
        np.mean(rolloff),
        np.mean(zero_crossing)
    ]

    for coeff in mfcc:
        features.append(np.mean(coeff))

    # Convert to array and reshape for model input
    features = np.array(features).reshape(1, -1)

    # Predict class
    prediction = model.predict(features)[0]

    print("🔊 Predicted Label:", prediction)
    return prediction


# ----------------------------
# MAIN
# ----------------------------

# if __name__ == "__main__":
#     test_audio = r"C:\Users\marya\PycharmProjects\animal\myapp\static\audio_dataset\Angry\car_extcoll0156.mp3"
#     print("🎧 Testing Audio:", test_audio)
#     result = predict_audio(test_audio)
#     print("✅ Final Prediction:", result)
