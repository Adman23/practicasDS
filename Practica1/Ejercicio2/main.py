import llm_classes
from transformers import pipeline


#https://www.youtube.com/watch?v=1h6lfzJ0wZw

model = pipeline("summarization", model="facebook/bart-large-cnn")
response = model("texto")
print(response)
