rm(list=ls())

library(ecb)
library(tidyverse)
library(purrr)
library(lubridate)
library(zoo)
library(vars)
library(svars)
library(openxlsx)
library(tsDyn)
library(urca)
library(fredr)

select <- dplyr::select  # Conflit avec les autres packages

pib <- get_data("MNA.Q.Y.I9.W2.S1.S1.B.B1GQ._Z._Z._Z.EUR.LR.N") %>%
  select(date=obstime,pib=obsvalue) %>%
  mutate(pib = log(pib)) %>%
  arrange(date) %>%
  mutate(date=gsub("-", "", date))

conso <- get_data("MNA.Q.Y.I9.W0.S1M.S1.D.P31._Z._Z._T.EUR.LR.N") %>%
  select(date=obstime,conso=obsvalue) %>%
  mutate(conso = log(conso)) %>%
  arrange(date) %>%
  mutate(date = gsub("-", "", date))

trade <- get_data("MNA.Q.Y.I9.W1.S1.S1.B.B11._Z._Z._Z.EUR.V.N") %>%
  select(date=obstime,trade=obsvalue) %>%
  arrange(date) %>%
  mutate(date = gsub("-", "", date)) %>%
  mutate(trade=-trade)

export <- get_data("MNA.Q.Y.I9.W1.S1.S1.D.P6._Z._Z._Z.EUR.LR.N") %>%
  select(date=obstime,export=obsvalue) %>%
  mutate(export = log(export)) %>%
  arrange(date) %>%
  mutate(date = gsub("-", "", date))

fbcf <- get_data("MNA.Q.Y.I9.W0.S1.S1.D.P51G.N11G._T._Z.EUR.LR.N") %>%
  select(date=obstime,fbcf=obsvalue) %>%
  mutate(fbcf = log(fbcf)) %>%
  arrange(date) %>%
  mutate(date=gsub("-","",date))

stock <- get_data("FM.Q.U2.EUR.DS.EI.DJES50I.HSTA") %>%
  select(date=obstime,stock=obsvalue) %>%
  mutate(stock = log(stock)) %>%
  arrange(date) %>%
  filter(!is.na(stock)) %>%
  mutate(date=gsub("-","",date))

deflator <- get_data("MNA.Q.Y.I9.W2.S1.S1.B.B1GQ._Z._Z._Z.IX.D.N") %>%
  select(date=obstime,dgdp=obsvalue) %>%
  mutate(date=gsub("-","",date),
         dgdp = log(dgdp)) %>%
  arrange(date) %>%
  filter(!is.na(dgdp))

cost <- get_data("MIR.M.U2.B.A2I.AM.R.A.2240.EUR.N") %>%
  select(date=obstime,cost=obsvalue) %>%
  mutate(cost = log(cost),
         date=as.yearmon(date, "%Y-%m"),
         year = year(date),
         quarter = quarter(date),
         date = paste0(year, "Q",quarter)) %>%
  group_by(date) %>%
  summarise(cost=mean(cost,na.rm=TRUE)) %>%
  ungroup()

prix <- get_data("ICP.M.U2.Y.XEFUN0.3.INX") %>%
  select(date=obstime,value=obsvalue) %>%
  mutate(date=as.yearmon(date, "%Y-%m"),
         year = year(date),
         quarter = quarter(date),
         date = paste0(year, "Q",quarter)) %>%
  group_by(date) %>%
  summarise(prix = mean(value)) %>%
  ungroup() %>%
  mutate(prix = log(prix)) %>%
  arrange(date) %>%
  filter(!is.na(pi))

pi <- prix %>%
  mutate(pi=100*(prix)-lag(prix)) %>%
  select(-prix) %>%
  drop_na()

asset <- get_data("BSI.M.U2.N.A.T00.A.1.Z5.0000.Z01.E") %>%
  select(date=obstime,asset=obsvalue) %>%
  mutate(date=as.yearmon(date, "%Y-%m"),
         year = year(date),
         quarter = quarter(date),
         date = paste0(year, "Q",quarter)) %>%
  group_by(date) %>%
  summarise(asset = mean(asset)) %>%
  ungroup() %>%
  mutate(asset = log(asset)) %>%
  arrange(date)