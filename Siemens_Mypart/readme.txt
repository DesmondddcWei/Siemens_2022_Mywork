1、以多部电梯的仿真为核心。输入为客流的数据，输出为每一个乘客的
乘坐时间。
2、在遗传优化中，Genetic为主函数


一、客流产生模块 客流发生器  

对于任何一个需求，根据泊松的概率，确定需求到来的时间。每个时间间隔只产生一个人的需求

随机确定需求的的产生楼层、目标楼层

0：仿真的总人数，仿真时间、时间间隔参数（每几秒新增一次需求？）
①随着时间，乘客到达的数量：泊松分布，注意lambda作为平均到达率，确定分布函数
②更具总的仿真时间和时间间隔参数来计算间隔数（一共产生了几次需求？）
③根据分布，得出每一个时间间隔里，需求的数量，也就是总人数乘比例，等于需求数（离散）

起始楼层的确定  
1、底层40，高层40，中间20. 所有人数里，按4,2,2随机分配给 高，中，低 （交通模式）
2、或者直接随机一个0-1中的数，然后落在哪个区间里就是哪一层 如果就是自己的层，再随机一次
目标楼层的确定  
1、对于底层和高层，去远端层的可能性大，去近处的可能性小。中间的平均
2、全部随机分配 （一般交通模式）
二、交通识别模块（不一定有）可以自己调整吗

三、群控调度算法模块（带有我们自己定的参数）

四、电梯仿真运行模块（主要）
五、结果分析模块