import os
import numpy as np
import cv2
from sklearn.model_selection import train_test_split
import tensorflow as tf
from tensorflow.keras.models import Sequential, load_model
from tensorflow.keras.layers import Conv2D, MaxPooling2D, Dropout, Flatten, Dense
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.optimizers import Adam


# CONFIGURATION

IMG_SIZE = 48
NUM_CLASSES = 4
BATCH_SIZE = 64
EPOCHS = 20

DATASET_PATH = r"C:\Users\marya\PycharmProjects\animal\dataset"  # folder containing subfolders of each class
MODEL_PATH = r"C:\Users\marya\PycharmProjects\animal\myapp\static\sequentialmodel1.h5"


# READ IMAGES AND LABELS

def load_dataset(path):
    images = []
    labels = []
    class_names = sorted(os.listdir(path))

    for idx, folder in enumerate(class_names):
        folder_path = os.path.join(path, folder)
        if not os.path.isdir(folder_path):
            continue
        for file in os.listdir(folder_path):
            file_path = os.path.join(folder_path, file)
            img = cv2.imread(file_path, cv2.IMREAD_GRAYSCALE)
            if img is None:
                continue
            img = cv2.resize(img, (IMG_SIZE, IMG_SIZE))
            images.append(img)
            labels.append(idx)

    X = np.asarray(images, dtype=np.float32) / 255.0
    y = np.asarray(labels, dtype=np.int32)
    X = X.reshape(X.shape[0], IMG_SIZE, IMG_SIZE, 1)
    print(f" Loaded {len(X)} images across {len(class_names)} classes")
    return X, y, class_names




# LOAD MODEL AND PREDICT

def read_dataset1(path):

    data_list = []
    img = cv2.imread(path, cv2.IMREAD_GRAYSCALE)
    if img is None:
        print(f" Failed to read image: {path}")
        return np.asarray(data_list, dtype=np.float32)
    res = cv2.resize(img, (IMG_SIZE, IMG_SIZE))
    data_list.append(res)
    return np.asarray(data_list, dtype=np.float32)


def predictcnn(img_path):
    dataset = read_dataset1(img_path)
    if dataset.size == 0:
        return []

    dataset = dataset.reshape(dataset.shape[0], IMG_SIZE, IMG_SIZE, 1) / 255.0


    model = load_model(MODEL_PATH, compile=False)
    yhat_classes = np.argmax(model.predict(dataset), axis=-1)
    return yhat_classes[0]



# MAIN EXECUTION

if __name__ == "__main__":



    # Test prediction
    test_image = r"C:\Users\marya\PycharmProjects\animal\myapp\static\dataset5\testimage\Screenshot 2025-10-13 181924.png"
    if os.path.exists(test_image):
        result = predictcnn(test_image)
        print(f" Predicted class index: {result}")
    else:
        print("️ Test image not found.")
