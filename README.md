# Image-Tag-Replacement-Real-Time

It was not allowed to share any codes from my work in LMS (Laboratory for Manufacturing Systems), being that I don't have them in my possesion. My latest Computer Vision Project in my department was the replacement of tags in images. I went a little further and applied my method on a real-time video, using only 10 frames/sec with an Intel Pentium Processor.

The imImpose(.) function is the main code and uses a feature-based method to locate certain patterns, called tags, in a reference image, estimates the geomtric transform from the xy-plane to the plane of the reference image, applies the transform on randomly chosen image, the replacement image, and replaces the tag with the latter in the reference image.
