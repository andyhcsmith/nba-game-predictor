require(data.table)
require(rvest)
require(surveillance)
require(gtools)

# Hello

teams = c("ATL","BRK", 'BOS','CHA','CHI', 'CHO','CLE','DAL','DEN','DET','GSW','HOU','IND','LAC',
         'LAL','MEM','MIA','MIL','MIN','NJN', 'NOH', 'NOP','NYK','OKC','ORL','PHI','PHO','POR','SAC','SAS','TOR','UTA','WAS')
years = seq(2017,2018,1)

teams_seasons = expand.grid(Team = teams, Season = years)
teams_seasons$team_year = paste0(teams_seasons$Team, '/', teams_seasons$Season)


# url = 'https://www.oddsportal.com/basketball/usa/nba/results/webpage = read_html(url)'
# games_html = html_nodes(webpage,'table') #%>% html_nodes("img")
# 
# season_data = data.table(html_table(games_html, fill = T)[[1]])
# season_data


season_scrapper = function(team_year){
  
  team = gsub('/.*','',team_year)
  season_data = data.table()
  url = paste0('https://www.basketball-reference.com/teams/', team_year ,'/gamelog/')
  webpage = read_html(url)
  games_html = html_nodes(webpage,'table')
  
  if (length(games_html) != 0){
    season_data = data.table(html_table(games_html)[[1]])
    colnames(season_data) = unlist(season_data[1,])
    colnames(season_data)[4] = 'Home'
    season_data = season_data[,Rk:=as.numeric(Rk)]
    season_data = season_data[!is.na(Rk)]
    season_data$Team = team
  } 
  
  return(season_data)
}

all_data = data.table()
all_data = plapply(teams_seasons$team_year, season_scrapper)

temp = do.call(rbind, all_data)
fwrite(temp, 'C:/Users/asmi797/OneDrive/Documents/Leisure/nba-game-predictor/data/br_games_data.csv')



require(readxl)
read_excel('file:///C:/Users/asmi797/OneDrive/Documents/Leisure/NBA Analysis/NBA Shiny App/Saved Data/betting_odds.xlsb')


