import cv2
import numpy as np


def transparente2magenta(path_name, out_path, cria_arquivo=False, extensao='png'):
  image = cv2.imread(path_name, cv2.IMREAD_UNCHANGED)
  for l in range(np.size(image, 0)):
    for a in range(np.size(image, 1)):
      if (image[l][a][3]) != 255:
        image[l][a] = np.array([255, 0, 254, 255])

  if cria_arquivo is True:
    cv2.imwrite(out_path[:-4] + '.' + extensao, image)
  else:
    return image