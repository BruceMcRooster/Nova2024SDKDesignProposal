# Nova SDK Design Proposal

## How To Use This Repository

This repository is intended to roughly outline a proposed design for the SDKs for each platform for Nova. In the [`sdk`](/sdk) directory, you will find a directory for each platform we are considering supporting ([python](/sdk/python), [javascript](/sdk/javascript), [swift](/sdk/swift), and [kotlin](/sdk/kotlin)). Each of these include the rough design for the API for that platform, including documentation in that language's style.

The [`examples`](/examples) directory includes examples of how the SDKs might be used in each language.

There is also an [`openapi.yaml`](/openapi.yaml) file that is a rough proposal for what features will be needed on the server end to support the SDKs. This is not a final design, but a rough outline of what the server will need to support.

*Note: This is **not** a final design and is meant to be discussed and modified. It should not be treated as a bible because I'm not that cracked at API design. Please critique: it's how this becomes the best it can be.*

## Overview

For this year's Nova, we want to enable participants to have simple access to AI models.
The hackathon is meant to appeal to different levels of experience, so enabling simple usage is imperative, but allowing for additional depth for those who are more experienced. Progressive disclosure of complexity is essential. Thus, the designs for this API is intended to be simple to start with and understand but also enable more advanced customization or usage without complicating the basic usage.
Also, API design should align with the typical design of the language it is implemented in, so any learnings are genuinely useful and transferable to future usage of a language and experienced users aren't fighting our SDK.

## Design Approaches For Each Language

### Python

* Does not support function overloading
* Functions should be called on objects to enable different functionality
* Functions should have reasonable variable defaults
* Function documentation should be easy to understand, especially since all options will be visible regardless of how much of the functionality is being used
* Parameter typing is a must. Editor hints are incredibly useful, especially for beginners

### JavaScript/TypeScript

* Does not support function overloading
* Options objects should be used to enable additional optional arguments
  * These should be well typed for TypeScript users and well documented for JavaScript users
* Simple React (or other framework) components could be really helpful. They hide some of the complexity of complicated reactivity in displaying chat text as it comes in, gradually rendering images, etc., allowing people to focus on building apps
  * This is probably less necessary than having a good API for writing non-UI code, but could be a nice-to-have

### Swift

* Supports function overloading
  * Progressive disclosure of complexity is a core tenant of Swift (see [here](https://www.youtube.com/watch?v=-3dct9nMM2g) if you have time)
* Functions should be called on objects to enable different functionality
* Functions should have reasonable variable defaults
* Xcode automatically makes the options look nice and like distinct options so as not to overwhelm a user
  * If two or more options must go together, write a simple wrapper function with those specific functions
* Simple SwiftUI components could be helpful for solving complicated state stuff, but the framework is pretty good at making these things simple, so it might be fine. If we have time, some components would definitely be appreciated

### Kotlin

* Supports function overloading
* Functions should be called on objects to enable different functionality
* Functions should have reasonable variable defaults
* All options will be visible regardless of how much of the functionality is being used
  * Distinct sets of parameters should be separated into different wrapper functions to minimize the number of discrete options at the call site
* Creating Jetpack Compose components, similar to SwiftUI, could be very helpful, but shouldn't be considered essential

## Functionality

Here, I’d like to outline the rough features that SDKs should provide, including general considerations for working with them, without diving into the individual design of the APIs themselves.

### Chat (Text Generation)

Chat should be the easiest to use. But it should also be able to power what are likely going to be some of the most advanced parts of apps.

I propose the following features to enable this (\* means less essential)

* Chatting
* Including prompt with chat
* Streaming responses (enabling typing effect)
* Stop sequences (model stops responding after outputting this set of characters)[^1]
* Tool use (generating calls to user-created functions)\*
* Image support\*[^2]
* Thoughtful models\*\*[^3]

#### General Considerations

* Well-documented, reasonable, model-dependent, and gracefully errored restraints should be put on length of inputs. Consider (maybe) a truncate option to let people easily input a request and have it truncated before being sent for processing?

[^1]:  Specifications surrounding this vary slightly between providers. OpenAI supports the fewest, at just 4 stop sequences. And whether or not the stop sequence is included seems to vary. Gemini doesn't include it, OpenAI does (I think). This would either have to be documented when we choose a model or normalized through the API.

[^2]:  This would hinge partially on the model we use under the hood (4o, Claude, Gemini, and Pixtral all support it, but Llama, Gemma, Mixtral, Phi-3 (there is a [Vision](https://techcommunity.microsoft.com/t5/ai-azure-ai-services-blog/phi-3-vision-catalyzing-multimodal-innovation/ba-p/4170251) variant) don't), and partially on our worries about bandwidth. Most models are limited to fairly reasonable image sizes, which we would reflect in our API, but could still be costly compared to text only.

[^3]:  This would highly depend on our provider. I'm imagining something like o1 serving this role, but this obviously is irrelevant if we don't use OpenAI.

### Image Generation

Image generation is a powerful tool that should be simple and functional with minimal configuration or tweaking. However, we are limited in model options that enable this without requiring extensive customization by the user (not minimal) or tweaking by us to try to find some sane defaults (not ideal). Therefore, this feature set is limited mainly by what is possible with almost any model (basically DALL·E 2, because other options have far more robust APIs).

I propose the following features given this (\* means less essential)

* Image creation from prompts
* Streaming previews (blurry thumbnail to actual image)
* Image editing/reprompting\*\*

#### General Considerations

* The OpenAI API does enable sending a unique user ID to detect abuse, which might enable us to avoid any abuse or infringement by people (I don’t expect it, but people are people) from shutting down image generation by anyone

### Speech To Text

Allowing hackathoners to take natural language from their users and convert it to text simply and easily will be essential for those hoping to build really usable apps.

This basically comes down to two features

* Initializing (setting up microphone access)
* Transcribing
  * Simple implementation could be a `start()` and `stop()` function that returns the processed values after finishing
    * Stop when silent?
  * Streaming implementation (similar to chat streaming) could allow realtime transcription for a slightly fancier appearance

#### General Considerations

* This could be done on-device[^4], especially for iOS ([Speech framework](https://developer.apple.com/documentation/speech/)) and Android ([SpeechRecognizer](https://developer.android.com/reference/android/speech/SpeechRecognizer) or [TFLite](https://github.com/tensorflow/examples/tree/master/lite/examples/speech_recognition/android)), and possibly with [TFLite](https://farmaker47.medium.com/offline-speech-to-text-with-tensorflow-and-the-whisper-model-d365f90fc1af) or [ONNX](https://medium.com/microsoftazure/build-and-deploy-fast-and-portable-speech-recognition-applications-with-onnx-runtime-and-whisper-5bf0969dd56b) models in the browser and for Python

[^4]:  Technically, the iOS Speech framework and Android SpeechRecognizer may use the cloud and require internet to work. This is a possible limitation, but this cloud service would be taken care of by Apple/Google, so it wouldn’t be our problem. We’d just have to outline it in the documentation. On iOS, the user’s native language will likely be downloaded and work without need for WiFi unless they have a pretty old phone. On Android, going to the cloud is more likely, but still not our problem as long as we properly say we need WiFi.

### Text To Speech

Allowing devices and tools to generate vocal responses is a cool way to make delightful interactive apps.

Again, two features

* Create speech (get audio from endpoint)
* Play this audio (making raw audio files available isn’t particularly user-friendly)
