# Taxonomy, Ontology, Wikipedia Corpus Processing, and Advanced Text Analysis Tool

## Overview

This project provides a comprehensive set of tools for processing taxonomies, extracting and analyzing Wikipedia content, and performing advanced text manipulation and analysis tasks. It leverages AI-powered techniques to enhance information extraction, text transformation, and semantic analysis.

## Main Functionalities

### 1. Taxonomy Processing and Wikipedia Matching

- Cleans and standardizes taxonomy terms
- Matches taxonomy terms with relevant Wikipedia pages
- Extracts and processes content from matched Wikipedia pages

### 2. AI-Powered Text Manipulation

- **Paraphrasing**: Restates text while maintaining original meaning
- **Rewriting**: Alters text more significantly, involving restructuring or expansion
- **Summarization**: Captures the essence of the original text in a condensed form
- Uses OpenAI's GPT-3.5-turbo model with few-shot learning approach for improved results

### 3. Advanced Text Analysis

- Generates multiple versions (paraphrases, rewrites, and summaries) of input text
- Analyzes common unigrams across different versions of each manipulation type
- Extracts final keywords that are consistent across all manipulation methods
- Identifies synonyms and initialisms (acronyms) related to specific terms
- Provides insights into the most consistent and important concepts in the text

### 4. Text Preprocessing and Feature Extraction

- **Text Preprocessing**: Converts text to lowercase, removes punctuation, tokenizes, and removes stopwords
- **TF-IDF Analysis**: Computes Term Frequency-Inverse Document Frequency scores to identify important words in a text
- **KeyBERT Keyword Extraction**: Utilizes BERT embeddings to extract contextually relevant keywords from text
- **TextRank Keyword Extraction**: Applies graph-based ranking model to extract keywords from text
- **Named Entity Recognition**: Identifies and extracts named entities (e.g., person names, organizations, locations) from text
- **LDA Topic Modeling**: Performs Latent Dirichlet Allocation to identify main topics and their key terms in the text
- **YAKE Keyword Extraction**: Uses statistical text features to extract keywords without the need for a corpus
- **Word Embeddings**: Utilizes word embedding models for semantic analysis

### 5. Performance Evaluation and Visualization

- **Keyword Extraction Evaluation**: Compares the results of different keyword extraction techniques against a list of correct keywords, providing metrics on correct and incorrect keywords found.
- **Results Visualization**: Creates a heatmap to visually represent the performance of different keyword extraction techniques.

## Key Features

- Handles multi-level taxonomies and Wikipedia content extraction
- Utilizes advanced AI models for various text manipulation tasks
- Implements few-shot learning for improved performance in text transformation tasks
- Performs detailed analysis of manipulated text to identify common elements and key concepts
- Compares consistency across different types of text transformations
- Extracts the most robust keywords that persist across all manipulation techniques
- Identifies synonyms and acronyms to expand term coverage
- Provides quantitative metrics for comparing the effectiveness of various text analysis methods
- Offers visual representation of results for easy interpretation and comparison

## Applications

- Building and enriching knowledge bases with Wikipedia content
- Generating variations of text for data augmentation in NLP tasks
- Creating and analyzing summaries of lengthy documents or articles
- Extracting key concepts, synonyms, and acronyms from complex texts
- Studying text consistency and key concept preservation across different manipulation techniques
- Assisting in content creation, revision, and condensation processes
- Analyzing the effectiveness of different text manipulation strategies
- Automated keyword and topic extraction for content indexing and search optimization
- Enhancing search functionality with synonym recognition
- Improving information retrieval systems with expanded query terms
- Automating the creation of glossaries or term databases
- Comparing different keyword extraction methods for optimal results in various contexts
- Benchmarking and improving text analysis algorithms
- Selecting the most effective technique for specific types of documents or domains
- Visualizing the strengths and weaknesses of different keyword extraction methods

## Installation

To install the required dependencies, run:

```
pip install -r requirements.txt
```

After installation, you also need to download a spaCy model. For English, you can use:

```
python -m spacy download en_core_web_sm
```

## How to Use

Here's an example of how to use the tool for keyword extraction and evaluation:

```python
# Input text to analyze
text = text_test  # Assume this is defined elsewhere in your code

# List of correct keywords for evaluation (based on rewrite)
correct_list = rewrite_keywords  # Assume this is defined elsewhere in your code

# Apply different keyword extraction techniques
technique_results = {
    'TF-IDF': tf_idf(text),
    'KeyBERT': keybert_extraction(text),
    'TextRank': textrank(text),
    'NER': named_entity_recognition(text),
    'Word Embeddings': word_embeddings(text),
    'LDA Topic Modeling': lda_topic_modeling(text),
    'YAKE': yake_extraction(text)
}

# Evaluate the performance of each technique
evaluation = evaluate_techniques(correct_list, technique_results)

# Print evaluation results
print("Rewrite List:")
print(correct_list)
print("Results:")
for technique, results in technique_results.items():
    print(f"\n{technique}:")
    print(f"Extracted keywords: {results}")
    print(f"Correct found: {evaluation[technique]['correct_found']}")
    print(f"Incorrect found: {evaluation[technique]['incorrect_found']}")
```

This script will:
1. Extract keywords using seven different techniques
2. Evaluate each technique's performance against a list of correct keywords derived from a rewrite of the original text
3. Print out the results, showing extracted keywords and performance metrics for each technique

You can customize this script by changing the input text, the list of correct keywords, or the techniques used for extraction.

Note: `text_test` and `rewrite_keywords` should be defined before running this script. `text_test` would typically be the text you want to analyze, and `rewrite_keywords` would be a list of keywords derived from a rewrite of the original text, which you consider correct for this analysis.

## Data Access Statement

This project uses various data sources:

### Wikipedia Data:

This project accesses and processes publicly available data from Wikipedia.
Users of this software are responsible for complying with Wikipedia's terms of use and data access policies.
For more information, please refer to Wikipedia's Terms of Use.


### OpenAI API Data:

This project utilizes OpenAI's API for certain text processing tasks.
Access to OpenAI's API requires an API key and is subject to OpenAI's usage policies and pricing.
Users of this software are responsible for obtaining their own API key and complying with OpenAI's terms of service.
For more information, please refer to OpenAI's API Terms of Use.


### User-Provided Data:

Any data provided by the user for processing remains the property of the user.
This software does not store or retain user-provided data beyond the immediate processing required for its functionality.


### Generated Data:

Data generated by this software (e.g., extracted keywords, analysis results) is derived from the above sources.
The ownership and usage rights of generated data may be subject to the terms of the input data sources.

Users of this software are responsible for ensuring they have the necessary rights and permissions to use, process, and store any data they input into or derive from this tool.

For questions about data access or usage, please contact Toby Gardner.

## Contributing

Toby Gardner

## License

This project is licensed under the MIT License - see the LICENSE file for details.
You are free to use, modify, and distribute this software, subject to the following conditions:

You must include the original copyright notice and the MIT License in any copy or substantial portion of the project.
You must comply with the terms of service of any third-party APIs or data sources used in this project, including but not limited to OpenAI's API and Wikipedia.

Please note:

This license does not grant you any rights to use OpenAI's or Wikipedia's names, logos, or trademarks.
This project is not endorsed by or affiliated with OpenAI or Wikipedia.