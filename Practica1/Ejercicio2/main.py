from llm_basic import *
from llm_decorators import *
import json


def cargar_json(nombre):
    with open(nombre, 'r') as archivo:
        data = json.load(archivo)
    return data


if __name__ == '__main__':
    nombre_archivo = 'config.json'
    json = cargar_json(nombre_archivo)

    input_text = json['text']
    summ_model_name = json["model_llm"]
    trans_model_name = json["model_translation"]
    expan_model_name = json["model_expansion"]
    input_lang = json["input_lang"]
    output_lang = json["output_lang"]


    summary_model = BasicLLM(input_text, summ_model_name)
    translation_model = TranslationDecorator(summary_model, trans_model_name, input_lang, output_lang)
    expansion_model1 = ExpansionDecorator(summary_model, expan_model_name)
    expansion_model2 = ExpansionDecorator(translation_model, expan_model_name)

    texto_resumido = (summary_model.process())
    print(f"\n\nEl texto resumido es el siguiente: \n {texto_resumido}")


    texto_traducido = (translation_model.process())
    print(f"\n\nEl texto traducido es el siguiente: \n {texto_traducido}")


    texto_expandido = (expansion_model1.process())
    print(f"\n\nEl texto expandido es el siguiente: \n {texto_expandido}")


    texto_traducido_expandido = (expansion_model2.process())
    print(f"\n\nEl texto traducido y luego expandido es el siguiente: \n {texto_traducido_expandido}")

