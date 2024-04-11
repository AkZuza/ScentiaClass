import pyttsx3
from PIL import Image
import pytesseract
text_speech=pyttsx3.init()
pytesseract.pytesseract.tesseract_cmd = r'C:\Users\dell\signlangdetection\tesseract'
print(pytesseract.image_to_string(Image.open('animal.jpg')))
text_speech.say(pytesseract.image_to_string(Image.open('animal.jpg')))
text_speech.runAndWait()



