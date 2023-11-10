import tensorflow as tf
import torch

print('\n\nGPU recognized by TensorFlow: {}'.format(len(tf.config.list_physical_devices('GPU')) > 0))
print('GPU recognized by PyTorch: {}'.format(torch.cuda.is_available() and torch.cuda.device_count() > 0))
