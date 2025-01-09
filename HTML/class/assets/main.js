let btn = document.getElementById('btn');

let apikey = 'WX2WLMGY7QNLM7XR3PEDYB2ED';

btn.addEventListener('click', fetchWeatherData);

async function fetchWeatherData() {
    try {
      let inputval = document.getElementById('input').value;
      const response = await fetch(
        `https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/${inputval}?unitGroup=metric&key=${apikey}&contentType=json`,
        {
          method: "GET",
          headers: {},
        }
      );
  
      // Check if the response is ok
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
  
      // Parse the response data
      const data = await response.json();
      console.log(data);
      let icon = data.currentConditions.icon;
      let conditions = data.currentConditions.conditions;
      let temp = data.currentConditions.temp;
      let windspeed = data.currentConditions.windspeed;
      let precipitation = data.currentConditions.precipprob;

      let htmlCondition = document.querySelector('#conditions');
      let htmlTemp = document.querySelector('#temp');
      let htmlWind = document.querySelector('#windspeed');
      let htmlPrecipitation = document.querySelector('#precipitation');

      // weather icon

      switch (icon) {
        case 'partly-cloudy':
            document.getElementById("image").src = "/assets/cloudy.png";
            break;
        case 'partly-cloudy-night':
            document.getElementById("image").src = "/assets/night.png";
            break;
        case 'cloudy':
            document.getElementById("image").src = "/assets/cloudy.png";
            break;
        case 'fog':
            document.getElementById("image").src = "/assets/cloudy.png";
            break;
        case 'snow':
            document.getElementById("image").src = "/assets/snow.png";
            break;
        case 'rain':
            document.getElementById("image").src = "/assets/rain.png";
            break;
        case 'clear-night':
            document.getElementById("image").src = "/assets/night.png";
            break;
        case 'wind':
            document.getElementById("image").src = "/assets/wind.png";
            break;
        case 'clear-day':
            document.getElementById("image").src = "/assets/sun.png";
            break;
        default:
            document.getElementById("image").src = "/assets/sun.png";
            break;
    }

      htmlCondition.innerText = 'Condition: ' + conditions;
      htmlTemp.innerText = 'Temperature: ' + temp + ' C';
      htmlWind.innerText = 'Windspeed: ' + windspeed + ' mph';
      htmlPrecipitation = 'Precipitation: ' + precipitation;

    } catch (err) {
      console.error("Error fetching weather data:", err);
    }
  }
  