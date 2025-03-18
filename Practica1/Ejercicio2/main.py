import llm_classes
import json


def cargar_json(nombre):
    with open(nombre, 'r') as archivo:
        data = json.load(archivo)
    return data


if __name__ == '__main__':
    nombre_archivo = 'config.json'
    json = cargar_json(nombre_archivo)

    summary_model = llm_classes.BasicLLM()
    translation_model = llm_classes.TranslationDecorator()
    expansion_model = llm_classes.ExpansionDecorator()


    texto_resumido = (summary_model.generate_summary(json["texto"], json["input_lang"], json["output_lang"], json["model_llm"]))
    print(f"\n\nEl texto resumido es el siguiente: \n {texto_resumido}")

    texto_traducido = (translation_model.generate_summary(texto_resumido, json["input_lang"], json["output_lang"], json["model_translation"]))
    print(f"\n\nEl texto traducido es el siguiente: \n {texto_traducido}")

    texto_expandido = (expansion_model.generate_summary(texto_resumido, json["input_lang"], json["output_lang"], json["model_expansion"]))
    print(f"\n\nEl texto expandido es el siguiente: \n {texto_expandido}")

    texto_traducido_expandido = (expansion_model.generate_summary(texto_traducido, json["input_lang"], json["output_lang"], json["model_expansion"]))
    print(f"\n\nEl texto traducido y luego expandido es el siguiente: \n {texto_traducido_expandido}")

