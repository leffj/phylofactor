#' Summary of phylofactor object for a given node or factor number
#' @export
#' @param PF PhyloFactor object
#' @param tree phylogeny (ape class)
#' @param taxonomy Taxonomy, first column is OTU ids in tree, second column is greengenes taxonomic string
#' @param node node number, must be in PF$nodes. Takes priority over "factor" for what is summarized
#' @param factor Factor number to summarize.
#' @param simplify.TaxaIDs Logical, whether or not to simplify IDs of group taxonomy to their shorest unique prefix (for each OTU in each group, this is taxonomy down to the coarsest taxonomic level unique to the OTU's group)
#' @return summary object. List containing $group and $complement info, each containing summary.group output for that group -  $IDs, $otuData and $PF.prediction
#' @examples
#' data("FTmicrobiome")
#' OTUTable <- FTmicrobiome$OTUTable        #OTU table
#' Taxonomy <- FTmicrobiome$taxonomy        #taxonomy
#' tree <- FTmicrobiome$tree                #tree
#' X <- FTmicrobiome$X                      #independent variable - factor indicating if sample is from feces or tongue
#'
#' rm('FTmicrobiome')
#'
#' # remove rare taxa
#' ix <- which(rowSums(OTUTable==0)<30)
#' OTUTable <- OTUTable[ix,]
#' OTUs <- rownames(OTUTable)
#' tree <- drop.tip(tree,which(!(tree$tip.label %in% OTUs)))
#'
#' par(mfrow=c(1,1))
#' phylo.heatmap(tree,t(clr(t(OTUTable))))
#' PF <- PhyloFactor(OTUTable,tree,X,nfactors=2,choice='var')
#'
#' FactorSummary <- phylofactor.summary(PF,Taxonomy,factor=1)
#'
#' str(FactorSummary)
#'
#' par(mfrow=c(1,2))
#' plot(FactorSummary$ilr,ylab='ILR coordinate',main='ILR coordinate of factor',xlab='sample no.',pch=16)
#' lines(FactorSummary$fitted.values,lwd=2,col='blue')
#' legend(x=1,y=-5,list('data','prediction'),pch=c(16,NA),lty=c(NA,1),col=c('black','blue'),lwd=c(NA,2))
#'
#' plot(FactorSummary$MeanRatio,ylab='ILR coordinate',main='Mean Ratio of Grp1/Grp2',xlab='sample no.',pch=16)
#' lines(FactorSummary$fittedMeanRatio,lwd=2,col='blue')
#' legend(x=1,y=-5,list('data','prediction'),pch=c(16,NA),lty=c(NA,1),col=c('black','blue'),lwd=c(NA,2))
phylofactor.summary <- function(PF,taxonomy,factor=NULL,tree=PF$tree,simplify.TaxaIDs=F){
  #summarizes the IDs of taxa for a given node identified as important by PhyloFactor. If subtree==T, will also plot a subtree showing the taxa
  if (is.null(factor)){stop('need to input a factor')}
  grp1 <- PF$groups[[factor]][[1]]
  grp2 <- PF$groups[[factor]][[2]]

  output <- NULL
  output$group1 <- summary.group(PF,tree,taxonomy,factor = factor,grp1,simplify=simplify.TaxaIDs)
  output$group2 <- summary.group(PF,tree,taxonomy,factor = factor,grp2,simplify=simplify.TaxaIDs)


  output$TaxaSplit <- TaxaSplit(output)
  output$glm <- PF$glms[[factor]]
  output$ilr <- PF$glms[[factor]]$y
  output$fitted.values <- PF$glms[[factor]]$fitted.values

  r <- length(grp1)
  s <- length(grp2)
  output$MeanRatio <- exp(output$ilr/(sqrt(r*s/(r+s))))
  output$fittedMeanRatio <- exp(output$fitted.values/(sqrt(r*s/(r+s))))


  class(output) <- 'PF summary'
  return(output)

}

