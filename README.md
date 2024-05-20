# MultienergyMS

This program is designed for plotting muti-energy two-dimensional mass spectrum.

## Input

The user needs to organize the input into the format shown in the demo below.

```R
demo <- create_demo()
```

```R
> demo 
# A tibble: 9 × 4
    mz1   mz2 range correlation
  <dbl> <dbl> <dbl>       <dbl>
1   371   192     1        -0.8
2   371   192     2        -0.4
3   371   192     3         0.5
4   371    73     1        -0.8
5   371    73     2        -0.2
6   371    73     3         0.8
7   192    73     1         0.2
8   192    73     2        -0.5
9   192    73     3        -0.8
```

Set parameters

```R
demo <- paraSet(df = demo, corThreshold = 0.8)
```

```R
> demo
# A tibble: 9 × 8
    mz1   mz2 range correlation min_mz max_mz  size color
  <dbl> <dbl> <dbl>       <dbl>  <dbl>  <dbl> <dbl> <dbl>
1   371   192     1        -0.8     73    371     4  -0.8
2   371   192     2        -0.4     73    371     6   0  
3   371   192     3         0.5     73    371    12   0  
4   371    73     1        -0.8     73    371     4  -0.8
5   371    73     2        -0.2     73    371     6   0  
6   371    73     3         0.8     73    371    12   0.8
7   192    73     1         0.2     73    371     4   0  
8   192    73     2        -0.5     73    371     6   0  
9   192    73     3        -0.8     73    371    12  -0.8
```

## Plot

```R
plotMultiMS(df = demo)
```

<img src=".\assets\image-20240520102035162.png" alt="image-20240520102035162" style="zoom:67%;" />