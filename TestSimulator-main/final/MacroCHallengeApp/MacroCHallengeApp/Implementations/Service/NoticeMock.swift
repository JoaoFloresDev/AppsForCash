//
//  NoticeMock.swift
//  MacroCHallengeApp
//
//  Created by André Papoti de Oliveira on 29/10/20.
//

import Foundation


func getNotice() -> Notice {
    let topics = [
        "Matemática":[
            "Operações com números inteiros e fracionários",
            "Sistema de medidas usuais",
            "Números racionais relativos",
            "Regra de três simples",
            "Porcentagem",
            "Juros simples",
            "Equação do primeiro grau e sistema simples do primeiro grau",
            "Equação simples do segundo grau",
            "Geometria plana (perímetro e área de polígonos regulares, medidas de ângulos)",
            "Teorema de Pitágoras",
            "Resolução de situação-problema",
            "Propriedades da multiplicação comutativa, associativa e distributiva",
            "Fatoração",
            "Simplificação de expressões algébricas.",
            "Produtos notáveis"],
        "Português":[
            "Interpretação de texto",
            "Sinônimos e antônimos",
            "sinônimos e antônimos",
            "acentuação gráfica",
            "flexão de gênero, número e grau do substantivo e do adjetivo",
            "crase",
            "emprego de pronomes e verbos",
            "emprego de preposições e conjunções",
            "concordância nominal e verbal",
            "predicação verbal",
            "modos verbais e conjugação",
            "acentuação",
            "sintaxe: tipos de sujeito e tipos de predicado",
            "figuras de linguagem",
            "linguagens e variações linguísticas"],
        "Ciências Naturais":[
            "Drogas: categorias, efeitos, problemas sociais e de  saúde decorrentes do uso",
            "métodos contraceptivos humanos",
            "sistema imunológico, antígenos e anticorpos, vacinas e soros",
            "antibióticos",
            "modo de transmissão, profilaxia e sintomas das doenças: AIDS, dengue, doença de Chagas e febre amarela",
            "características básicas dos seres vivos: organização celular, subsistência – obtenção de matéria e energia e reprodução",
            "os reinos dos seres vivos",
            "tipos de ambientes e especificidade como caracterização, localização geográfica, biodiversidade, proteção e conservação dos ecossistemas brasileiros",
            "relações alimentares – produtores, consumidores e decompositores e transferência de energia entre seres vivos",
            "consequências ambientais do desmatamento indiscriminado",
            "importância da reciclagem do papel",
            "visão geral de propriedades dos materiais, como cor, dureza, brilho, temperaturas de fusão e de ebulição, condutividade elétrica, permeabilidade e suas relações com o uso no cotidiano e no sistema produtivo",
            "minerais, rochas e solos – características gerais e importância para a obtenção de materiais como metais, cerâmicas, vidro, cimento e cal",
            "tecnologia da cana – açúcar e álcool",
              "tecnologia do petróleo",
              "processos físicos de separação de misturas",
              "análise dos conceitos de substância simples, substância pura, mistura, fase e componente",
              "poluição do ar, água e do solo: fontes e efeitos sobre a saúde",
              "efeito estufa e aquecimento global",
              "tratamento de água e esgoto",
              "saneamento básico",
              "a coleta e os destinos do lixo: coleta seletiva, lixões, aterros, incineração, reciclagem e reaproveitamento de materiais",
              "o consumo consciente e a importância dos 3Rs (reduzir, reutilizar e reciclar)",
              "materiais como fonte de energia: petróleo, carvão, gás natural e biomassa como recursos energéticos",
              "interpretação das leis ponderais",
              "análise cronológica da evolução atômica",
              "noções de reações químicas",
              "situações simples do cotidiano que envolvam: movimentos dos corpos (cinemática escalar)",
              "densidade",
              "transformações de energia",
              "aplicações das Leis de Newton",
              "eletricidade básica (átomo, corpos condutores e isolantes, eletrizados e neutros, montagem de circuitos elétricos simples)",
              "magnetismo (ímãs e campo magnético)",
              "ondas (classificações)"],
        "Ciências Humanas":["Lugar, paisagem e espaço geográfico",
             "noções básicas de cartografia e geomorfologia",
             "paisagens naturais e suas relações biogeográficas (os grandes biomas terrestres)",
             "aspectos naturais e socioeconômicos do Brasil",
             "questões ambientais gerais e as relações sociedade-natureza",
             "aspectos gerais do crescimento, distribuição e movimentos migratórios populacionais",
             "organização geopolítica do mundo contemporâneo e os conflitos armados regionais",
             "o cenário econômico mundial no contexto da globalização",
             "noções gerais dos aspectos geopolíticos no mundo contemporâneo",
             "a Antiguidade Clássica (Grécia e Roma)",
             "a Alta Idade Média (os Impérios Cristãos e o Islamismo); a Formação do Feudalismo",
             "a transição",
             "feudo-capitalista",
             "Estados Modernos Absolutistas",
             "a expansão marítima",
             "a colonização da América",
             "o Iluminismo e as Revoluções Burguesas",
             "a crise do sistema colonial e a América independente",
             "o Brasil Imperial",
             "o século XIX: Liberalismo, Nacionalismo, Socialismo e Imperialismo",
             "o Brasil Republicano: a República Velha, a Era Vargas, o Período Democrático",
             "a Primeira e a Segunda Guerras Mundiais",
             "a Guerra Fria",
             "a Ditadura Militar no Brasil",
             "a crise do Socialismo Real",
             "o Neoliberalismo",
             "Liberalismo econômico"]]
    
    let numberOfQuestionPerTopic = [
        "Matemática": 15,
        "Português": 15,
        "Ciências Naturais": 15,
        "Ciências Humanas": 5]
    
    let essay = [
        "Tema":"considera-se se o texto do candidato atende ao tema proposto. A fuga completa ao tema proposto é motivo suficiente para que a redação não seja corrigida em qualquer outro de seus aspectos, recebendo nota 0 (zero) total.",
        "Estrutura":"consideram-se aqui, conjuntamente, os aspectos referentes ao gênero/tipo de texto proposto e à coerência das ideias. A fuga completa ao gênero/tipo de texto é motivo suficiente para que a redação não seja corrigida em qualquer outro de seus aspectos, recebendo nota 0 (zero) total. Avalia-se aqui como o candidato sustenta seu ponto de vista em termos argumentativos e como essa argumentação está organizada, considerando-se a macroestrutura do texto (introdução, desenvolvimento e conclusão). Será considerada aspecto negativo a referência direta à situação imediata de produção textual (ex.: como afirma o autor do primeiro texto/da coletânea/do texto I; como solicitado nesta prova/proposta de redação). Na coerência, será observada, além da pertinência dos argumentos mobilizados para a defesa do ponto de vista, a capacidade do candidato de encadear as ideias de forma lógica e coerente (progressão textual). Serão consideradas aspectos negativos a presença de contradições entre as ideias, a falta de partes da macroestrutura do texto, a falta de desenvolvimento das ideias e a presença de conclusões não decorrentes do que foi previamente exposto.",
        "Expressão":"consideram-se nesse item os aspectos referentes à coesão textual e ao domínio da norma-padrão da língua portuguesa. Na coesão, avalia-se a utilização dos recursos coesivos da língua (anáforas, catáforas, substituições, conjunções etc.), de modo a tornar a relação entre frases e períodos e entre os parágrafos do texto mais clara e precisa. Serão considerados aspectos negativos as quebras entre frases ou parágrafos e o emprego inadequado de recursos coesivos. Na modalidade, serão examinados os aspectos gramaticais, tais como ortografia, acentuação, pontuação, regência, concordância (verbal e nominal) etc., bem como a escolha lexical (precisão vocabular) e o grau de formalidade/informalidade expressa em palavras e expressões."]
    
    let notice = Notice(topics: topics,
                        numberOfQuestionsPerTopic: numberOfQuestionPerTopic,
                        essay: essay,
                        linkNotice: "https://cti.feb.unesp.br/Home/vestibulinho/vestibulinho-2021.pdf",
                        durationTime: "4:30")
    return notice
}
