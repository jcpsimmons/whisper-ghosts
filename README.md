# Whisper ghosts

Give OpenAI's Whisper 30 seconds of silence and it writes something anyway. In English it says "Thank you." Tell it the silence is Arabic and it writes "Translation by Nancy Qanqar." Czech gives you "Subtitles created by JohnyX," French credits Radio-Canada's subtitling, and Chinese asks you to like, subscribe, share and tip a channel.

Nobody said any of it. The file is all zeros.

These scripts reproduce the whole thing on your own computer, one step at a time. I made them for a video on [my channel](https://www.youtube.com/channel/UC4sdJIrKWKxymZ5lwVSBzTw) and I run them on camera, so they print clean output you can read at a glance.

## Quick start

You need ffmpeg and Python 3.

```bash
git clone https://github.com/jcpsimmons/whisper-ghosts.git
cd whisper-ghosts
./scripts/setup.sh
./scripts/run-all.sh
```

`setup.sh` installs Whisper into a local `.venv` folder. The first run downloads the turbo model, about 1.5 GB. If you already have `whisper` on your PATH, skip setup and the scripts will use yours.

## The steps

| Script | What it does |
|---|---|
| `01-make-silence.sh` | Makes `audio/silence.wav`, 30 seconds where every sample is zero, then measures it with ffmpeg so you can see it's silent. |
| `02-thank-you.sh` | Gives Whisper the silence and says it's English. |
| `03-ghost-credit.sh` | Same silence, labeled Arabic. First on OpenAI's default settings, then twice with greedy decoding, and checks that the two runs match byte for byte. |
| `04-roll-call.sh` | The silence in 12 languages. Pass your own language codes to change the list: `./scripts/04-roll-call.sh it ko vi` |
| `05-noise.sh` | Optional. Fan noise, quiet room tone and 60 Hz hum instead of silence. |
| `outro.sh` | The computer reads the sign-off out loud with the macOS `say` command. `--save` writes it to `out/outro.wav` instead of playing it. |
| `run-all.sh` | Everything above, in order. |

Transcripts land in `out/` and generated audio in `audio/`. Git ignores both, so delete them whenever you like and the scripts will make them again.

## What I got

On an Apple Silicon Mac with openai-whisper 20250625, the turbo model and greedy decoding, the silence came back as:

| Language | What Whisper wrote | In English |
|---|---|---|
| English | Thank you. | |
| Arabic | ترجمة نانسي قنقر | Translation by Nancy Qanqar |
| Czech | Titulky vytvořil JohnyX. | Subtitles created by JohnyX. |
| Turkish | Altyazı M.K. | Subtitles: M.K. |
| French | Sous-titrage Société Radio-Canada | Subtitling: Société Radio-Canada |
| Chinese | 请不吝点赞 订阅 转发 打赏支持明镜与点点栏目 | Please like, subscribe, share and tip to support the Mingjing and Diandian program |
| Japanese | ご視聴ありがとうございました | Thank you for watching. |
| Russian | Продолжение следует... | To be continued... |
| Korean | 감사합니다. | Thank you. |
| German | Vielen Dank. | Thank you very much. |
| Spanish | Gracias. | Thanks. |
| Portuguese | E aí | Hey there |

The noise clips came back "Thank you." too. Same settings, same output, every run.

## Settings change which ghost you get

OpenAI's command line tool uses beam search by default: it keeps 5 candidate transcripts going and picks the best one. On Arabic silence that gives you اشتركوا في القناة, "Subscribe to the channel." Greedy decoding takes the single most likely next word every time, and that's where the credits show up. `03-ghost-credit.sh` runs both so you can see the difference. mlx-whisper only does greedy, and other model sizes produce other ghosts.

So your results can differ from my table. The habit underneath stays put: when nothing is being said, Whisper writes what usually came at the end of a video.

## Why it does this

OpenAI's [Whisper paper](https://arxiv.org/abs/2212.04356) says the model learned from 680,000 hours of audio paired with transcripts from the internet. It doesn't say where on the internet. Subtitle files often end with a credit line or a "thanks for watching" sitting over the closing music or silence. Learn from enough of those and silence starts to mean "the credits are coming."

Microsoft hit the same thing when its Azure version of Whisper stamped an Amara.org subtitle credit onto French transcripts. Its support team, relaying the speech product group, [called it](https://learn.microsoft.com/en-us/answers/questions/1495252/how-to-remove-the-generated-sous-titres-r-alis-s-p) hallucination "because of its training data" and "expected behavior."

It isn't rare. A [2025 study](https://arxiv.org/abs/2501.11378) fed Whisper large-v3 more than 300,000 clips with no speech in them, and about 40% came back with words. "Thank you" and "thanks for watching" made up about a third of those. OpenAI's own [model card](https://github.com/openai/whisper/blob/main/model-card.md) warns that the output may include text that was never spoken.

If you build on Whisper, cut the silence out before it reaches the model (voice activity detection does this) and check the `no_speech_prob` value Whisper reports for each segment.

## About the names

Some of these ghosts are real people's subtitle credits. Somebody typed a credit onto a video years ago, and now it comes out of a speech model when the room is quiet. Please don't go looking for them. None of them asked to end up inside a speech model.

## Options

```bash
BACKEND=mlx ./scripts/04-roll-call.sh     # mlx-whisper, much faster on Apple Silicon
MODEL=small ./scripts/02-thank-you.sh     # any Whisper model name
VOICE=Zarvox ./scripts/outro.sh           # any voice from: say -v '?'
```

macOS ships a voice named Whisper. `VOICE=Whisper ./scripts/outro.sh` if you want the joke.

## Sources

- [The GitHub discussion](https://github.com/openai/whisper/discussions/2608) where the Arabic silence result was posted
- [Robust Speech Recognition via Large-Scale Weak Supervision](https://arxiv.org/abs/2212.04356), the Whisper paper
- [Investigation of Whisper ASR Hallucinations Induced by Non-Speech Audio](https://arxiv.org/abs/2501.11378), ICASSP 2025
- [Careless Whisper: Speech-to-Text Hallucination Harms](https://arxiv.org/abs/2402.08021), FAccT 2024
- [Whisper model card](https://github.com/openai/whisper/blob/main/model-card.md)

MIT license. Fork it, break it, find new ghosts.

\- Dr. J
