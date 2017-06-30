# Characterizing eye shape
M.Tech Final Year Research Project 

Following methods have been used to find the objective of characterizing the eye shape with minimum curves - 

1. Used Single Scale Retinex technique to enhance the acquired image and post-processing
technique like edge map extraction was implemented using Relative Total Variance process.

2. Used Circular Hough Transform on this map to detect the iris and pupil circles.

3. Used a polynomial of second degree to fit upper and lower eyelids.

After setting up the required directories as mentioned inside the code files, run the file main_UBIRISv2.m

It takes approximately 2s to segment an image of UBIRIS dataset of visible wavelength.
