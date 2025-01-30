public with sharing class PokemonController {
    public String pokemonName { get; set; }
    public Boolean pokemonFound { get; set; }
    public Map<String, Object> pokemonDetails { get; set; }

    public PokemonController() {
        pokemonName = '';
        pokemonFound = false;
        pokemonDetails = new Map<String, Object>();
    }

    public void findPokemon() {
        try {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://pokeapi.co/api/v2/pokemon/' + EncodingUtil.urlEncode(this.pokemonName.toLowerCase(), 'UTF-8'));
            request.setMethod('GET');
            HttpResponse response = http.send(request);
    
            if (response.getStatusCode() == 200) {
                pokemonDetails = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
    
                Map<String, Object> sprites = (Map<String, Object>) pokemonDetails.get('sprites');
                String imageUrl = (String) sprites.get('front_default');
    
                pokemonDetails.put('imageUrl', imageUrl);
                pokemonFound = true;

                PokeQueue pq = new PokeQueue(imageUrl, (String)pokemonDetails.get('name'));
                // pq.imageUrl = imageUrl;
                // pq.imageAlt = (String)pokemonDetails.get('name');
                System.enqueueJob(pq);
    
            } else {
                pokemonFound = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Pokémon not found.'));
            }
        } catch (Exception e) {
            pokemonFound = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'An error occurred: Please Valid Name'));
        }
    }
    
}