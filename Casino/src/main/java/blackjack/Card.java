package blackjack;

public class Card {
    private final String suit;
    private final String rank;


    public Card(String suit, String rank) {
        this.suit = suit;
        this.rank = rank;
    }

    public String getRank() {
        return rank;
    }

    public int getValue() {
        if("JQK".contains(rank)) return 10;
        if(rank.equals("A")) return 11;
        return Integer.parseInt(rank);
    }

    public String getSuit() {
        return suit;
    }

    @Override
    public String toString() {
        return rank + " of " + suit;
    }
}
