# CSE-Projects
This repo is collection of all my semester projects.

# Projects
```
1. Compiler Design ( 4th Semester ) - 
Implementation of Lambda Calculus Grammer and Conversion of Lambda Calculus to equivalent C code. The code does
not support alpha or beta reductions. This is just a basic interpretation of Lambda Calculus and therefore the code 
considers that all variables with same name are the same variables and therfore does not perform any alpha-reduction.
* Lx.Ly.xy.(Lx.Ly.yx) === Lx.Ly.xyyx
* Lx.Ly.xy.(Lx.Ly.yx) !== Lx.Ly.xy.(La.Lb.ba)
The code generates an equivalent C code that performs and gives result for beta reduction. All variables are 
considered to be strings.
Lambda Calculus Grammer used:
<λexp> ::=> <var>             || 
            λ <var> . <λexp>  || 
            ( <λexp> <λexp> )
 
```
