Firstly, load the raw data files into R using read.table. In this step, datain different files should be merged, like in \*train.txt and \*test.txt.

Secondly, features names are extracted from the file of features.txt. The trick is to extract only the columns with mean or std.

Then, some basic changes are done, like changing column names.

Finally, aggregate is used to get the mean of the variables.

