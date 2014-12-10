init = ->
  days = <[neděle pondělí úterý středa čtvrtek pátek sobota]>
  months = <[ledna února března dubna května června července srpna září října listopadu prosince]>
  new Tooltip!watchElements!
  width = ig.containers.base.offsetWidth
  svatky =
    * day: 1 month: 0 reason: "Nový rok"
    * day: null month: 3 reason: "Velikonční pondělí", isVelikonoce: yes
    * day: 1 month: 4 reason: "Svátek práce"
    * day: 8 month: 4 reason: "Den vítězství"
    * day: 5 month: 6 reason: "Den slovanských věrozvěstů Cyrila a Metoděje"
    * day: 6 month: 6 reason: "Den upálení mistra Jana Husa"
    * day: 28 month: 8 reason: "Den české státnosti"
    * day: 28 month: 9 reason: "Den vzniku samostatného československého státu"
    * day: 17 month: 10 reason: "Den boje za svobodu a demokracii"
    * day: 24 month: 11 reason: "Štědrý den"
    * day: 25 month: 11 reason: "1. svátek vánoční"
    * day: 26 month: 11 reason: "2. svátek vánoční"
  years = [2010 to 2030].map (year) ->
    weekends = 0
    workdays = 0
    svatkyData = []
    {year, weekends, workdays, svatkyData}
  precomputeSvatek = (svatek, i, ii) ->
    year = years[ii]
    date = new Date!
      ..setHours 12
      ..setDate svatek.day
      ..setMonth svatek.month
      ..setYear year.year
    day = date.getDay!
    isWeekend = day == 0 or day == 6
    if svatek.isVelikonoce
      isWeekend = no
    index = if isWeekend
      year.weekends++
    else
      year.workdays++
    year.svatkyData[i] = {isWeekend, index, date}


  rectWidth = 20
  titleWidth = 100
  leftEnd = Math.floor width / 2 - titleWidth / 2
  rightStart = Math.ceil width / 2 + titleWidth / 2
  console.log leftEnd, rightStart
  container = d3.select ig.containers.base
  container.append \div
    ..attr \class \legend
    ..html "<span class='weekends'>Víkendy</span><span class='workdays'>Pracovní dny</span>"
  container.selectAll "div.year" .data years .enter!append \div
    ..attr \class \year
    ..append \h2 .html (.year)
    ..selectAll \div.svatek .data svatky .enter!append \div
      ..each -> precomputeSvatek ...
      ..attr \class (d, i, ii) ->
          {index, isWeekend} = years[ii].svatkyData[i]
          "svatek #{if isWeekend then 'weekend' else 'workday'}"
      ..style \top (svatek, i, ii) ~>
        {index, isWeekend} = years[ii].svatkyData[i]
        "#{rectWidth * (index % 2)}px"
      ..style \left (svatek, i, ii) ~>
        {index, isWeekend} = years[ii].svatkyData[i]
        if isWeekend
          leftEnd - rectWidth * (1 + (Math.floor index / 2))  + "px"
        else
          rightStart + rectWidth * (Math.floor index / 2)  + "px"
      ..attr \data-tooltip (it, i, ii)->
        year = years[ii]
        {index, isWeekend, date} = years[ii].svatkyData[i]
        if it.isVelikonoce
          "#{it.reason}"
        else
          "#{it.reason}: #{it.day}. #{months[it.month]} #{year.year} &ndash; #{days[date.getDay!]}"




if d3?
  init!
else
  $ window .bind \load ->
    if d3?
      init!
