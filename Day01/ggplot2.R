library(ggplot2)
library(plyr)
load('~/Dropbox/Namskeid/ggplot2/work.Rdata')

## empty plot
p <- ggplot()

## add layer to the plot

p + layer(data=minke, mapping=aes(x=age, y=length), 
  geom = 'point', stat='identity', position = 'identity')

## alternatively

p + geom_point(aes(age,length), data = minke)

## or with global data and aes mapping

ggplot(minke,aes(age,length)) + geom_point()

## different geoms:

ggplot(minke, aes(length)) + geom_histogram()

ggplot(minke, aes(maturity)) + geom_bar()

ggplot(minke, aes(age, length, group = round_any(age,5))) + geom_boxplot()

## adding layers together

ggplot(minke, aes(age, length, group = round_any(age,5))) +
  geom_boxplot() + geom_point()

ggplot(minke, aes(age, length, group = round_any(age,5))) +
  geom_boxplot() + geom_point() +
  geom_smooth(aes(age,length, group = 1))

## add color to aur graphs
ggplot(minke, aes(age, length)) +
  geom_point(col = 'red')

ggplot(minke, aes(age, length, col = sex)) +
  geom_point(size=4) + geom_smooth(aes(age, length),col=1)

ggplot(minke, aes(length, fill = sex)) + geom_histogram(position = 'dodge') 

## position of geoms
ggplot(minke, aes(maturity,fill = NS)) + geom_bar(position = 'dodge')
ggplot(minke, aes(maturity,fill = NS)) + geom_bar(position = 'stack')

ggplot(minke, aes(maturity, length, col = maturity)) + geom_jitter()

## faceting

ggplot(minke, aes(age, length)) + geom_point() +
  facet_wrap(~maturity) + geom_smooth()

ggplot(minke, aes(age, length)) + geom_point() +
  facet_wrap(~sex + NS) + geom_smooth()


ggplot(minke, aes(age, length)) + geom_point() +
  facet_grid(year+sex~NS)

## stats

## mean length by maturity class

ggplot(minke, aes(maturity, length)) +
  geom_point() + stat_summary(fun.y = 'mean', size = 6, geom='point',
                              col = 'red')


## vonB curve 
vonB <- function(linf,k,a,t0){
  gr <- linf * (1 - exp(-k * (a-t0)))
  return(gr)
}


minGr <- function(x){
  est.len <- vonB(x[1],x[2],minke$age)
  sum((minke$length - est.len)^2,na.rm=TRUE)
}

est.vonB <- nlm(minGr,c(800,0.2))



ggplot(minke,aes(age, length)) + geom_point() +
  stat_function(fun=function(a){
    vonB(est.vonB$estimate[1],est.vonB$estimate[2],a)
  },
                col='black',lty=2, lwd = 2)


## Labels

ggplot(minke, aes(age, length,col=sex)) + geom_point() +
  xlab('Age') + ylab('Length') + labs(title = 'Age -- Length') 

## Themes

ggplot(minke, aes(age, length)) + geom_point() +
  xlab('Age') + ylab('Length') + labs(title = 'Age -- Length') +
  theme_bw()


## Let's add this all together
library(geo)

eff.plot <- ggplot(minke, aes(lon,lat,col=sex)) +

  ## depth contours (as polygons
  geom_polygon(data=gbdypi.100,alpha=0.1,col='gray90') +
  geom_polygon(data=gbdypi.200,alpha=0.1,col='gray90') + 
  geom_polygon(data=island,col='gray90') +

  ## locations
  geom_point() +

  ## coordinate map (changed from cartesian to mercator)
  coord_map('mercator', xlim=c(-28,-11),ylim=c(62.5,68)) +
  xlab('Longitude') +
  ylab('Latitude') + 

  ## manual scales
  scale_colour_manual(values=c('red','blue','green')) +

  ## themes and change the legend position
  theme_bw() +
  theme(panel.border = element_rect(colour='black',size = 2),
        legend.position=c(0.9, 0.85),
        legend.background = element_rect(fill='white')) +

  ## gridlines
  scale_x_continuous(breaks=seq(-26,-11,2))  +
  scale_y_continuous(breaks=seq(63, 67, 1)) 


## and with facets

eff.plot + facet_wrap(~year, ncol = 3)

## Extensions

library(ggmap)
dunhagi <- ggmap(get_map('Dunhagi 5',zoom = 14))

library(gridExtra)
grid.arrange(eff.plot, ggplot(minke,aes(age,length)) + geom_point(), ncol=2)
grid.arrange(eff.plot, dunhagi,ncol=2)

