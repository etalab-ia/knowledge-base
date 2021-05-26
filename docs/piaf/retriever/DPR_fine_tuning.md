# DPR Fine-Tuning (finally)

```{hint}
**TLDR**: To fine-tune camemBERT with the DPR objective I did the following:
1. Crated a Q&A French dataset following the DPR format (using PIAF, FQuAD, French-SQuAD). Dataset [here](https://drive.google.com/file/d/1W5Jm3sqqWlsWsx2sFpA39Ewn33PaLQ7U/view?usp=sharing).
2. Modified the DPR [code to create](https://github.com/psorianom/DPR) a `CamembertTokenizer`.
3. Ran the training on 8 GPUs (thanks Jean Zay!).
4. [Converted](https://github.com/psorianom/DPR/tree/master/dpr2hf) the DPR output to a `transformers` compatible model.
5. Published the [question encoder](https://huggingface.co/etalab-ia/dpr-question_encoder-fr_qa-camembert) and [context encoder](https://huggingface.co/etalab-ia/dpr-ctx_encoder-fr_qa-camembert) in the Hugging Face model's hub.

Finally, I ran some experiments using our service-public.fr test set. **DPR is not better than BM25 ¯\\_(ツ)_/¯**.

```

## 0. Intro

Previously ({doc}`./DPR_performance`), I was failing to fine-tune camemBERT on a French Q&A dataset. It was not working due to a bug and to the different nature of my training dataset (a single hard negative context although I don't believe this was the cause but wadever). Anyways, now it is working. Here are the steps I followed to fine tune a camemBERT with the DPR objective.

## 1. Creation of a DPR dataset

The [DPR](https://github.com/facebookresearch/DPR) training script expects a dataset of this format: 

```
[
    {
        "question": "...",
        "answers": ["...", "...", ... ],
        "ctxs": [
            {
                "id": "...", # passage id from database tsv file
                "title": "",
                "text": "....",
                "score": "...",  # retriever score
                "has_answer": true|false
     },
]
```

I transformed a SQuAD-like dataset (such as PIAF) and got a file using the format above.

## 2. DPR original code modification

The original DPR code deals with BERT or RoBERTa architectures by default. Given that camembert is a RoBERTa architecture, we can leverage that while running their training script. Still, I had to directly instantiate a `CamembertTokenizer`. I believe I did this because RoBERTa expects its specific vocabulary files (splits and vocab or something like that). CamemBERT has only the bpe trained model and vocab.txt, so to make simple, I just instantiated a `CamembertTokenizer` instead of a `RobertaTokenizer`.

To be able to directly instantiate a `CamembertTokenizer` in DPR's code, I modified the code a little bit. The fork where I store that is [here](https://github.com/psorianom/DPR).


## 3. Training DPR

The parameters I used are below: 
```bash
python -m torch.distributed.launch --nproc_per_node=8 train_dense_encoder.py \
 --max_grad_norm 2.0 \
 --encoder_model_type fairseq_roberta \
 --pretrained_file data/camembert-base \
 --seed 12345 \
 --sequence_length 256 \
 --warmup_steps 1237 \
 --batch_size 16 \
 --do_lower_case \
 --train_file ./data/DPR_FR_train.json \
 --dev_file  ./data/DPR_FR_dev.json \
 --output_dir ./output/ \
 --learning_rate 2e-05 \
 --num_train_epochs 35 \
 --dev_batch_size 16 \
 --val_av_rank_start_epoch 30 \
 --pretrained_model_cfg ./data/camembert-base/
```

@Etalab, we are using CNRS' super computer, [Jean Zay](http://www.idris.fr/eng/jean-zay/jean-zay-presentation-eng.html).


## 4. Convert DPRs output to be Huggin Face's `transformers` compatible

To be able to use `transformers`, we have to extract the models from DPR's check point output. This checkpoint contains both models (context and question encoder) plus some other structures.

Given that I had trained a camembert, I had to then convert the original `fairseq` RoBERTa model into a Hugging Face model.

The code used to do this conversion is [here](https://github.com/psorianom/DPR/tree/master/dpr2hf).

## 5. Publication of the models in Hugging Face's hub

I uploaded the trained files to HF hub. Unfortunately, `transformers` just changed to v4.0 and it is now incompatible with `haystack`. Plus, it seems that you need `transformers` v4.0 to be able to instantiate the model using the name. Bref, the easier way to use it is to download each model files and save them locally and pass the required string to `haystack`'s `DensePassageRetriever`. 

## Some Results

Unfortunately, DPR does seem to perform better than our bm25 baseline. Still, it performs better than `sbert`, which is nice. A possible combination of bm25 + dpr as suggested in the original paper is in PIAF's backlog.


