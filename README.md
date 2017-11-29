# MetaMerge
Work with VOC files to support bounding boxes for tensorflow -> annotation concatenation and json&lt;->XML transcoding

# MetaMerge-support
This is the support page for "MetaMerge- supporting the transmogrification of Labelled Images for use in TensorBox and other Entity Detection Systems.

I recognized

Found some problems?

Post the problem to our Github issues page
https://github.com/dhushon/MetaMerge-support/issues

Thank you.

# Supported Types
Currently we support:
RectLabel versions of XML & JSON annotation files [inout] - (https://rectlabel.com)
TensorBox JSON annotation files [inout] - (https://github.com/Russell91/TensorBox)

# Developer Insights
MetaMerge has been built in Swift 4.0 using the new Encoder/Decoder -> Codable styles
- customization has been provided to take XML -> a Dictionary that can then be used by the Decoders, however there is not yet a custom encoder [TODO]


# Key features
- ability to concatenate / single-ify annotations depending on the target engine

# Remaining ToDo's:
- deal with ClassID's and UID's associated with TensorBox models... current handling is unique, but not sophisticated nor correct
- buildout graphical controller
- test image loading w/ box overlays
- provide image scaling services alongside re-sizing the declared boxes
- concentrate coders/decoders under a more consistent file structure/strategy -> right now the A->B, A->C, B->C structures/strategies are messy (multi-file changes)

