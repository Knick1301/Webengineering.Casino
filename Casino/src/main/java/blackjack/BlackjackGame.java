package blackjack;

import java.util.ArrayList;
import java.util.List;

public class BlackjackGame {
    private Deck deck;
    private List<List<Card>> playerHands;
    private List<Card> dealerHand;
    private boolean isGameOver;
    private int currentHandIndex;
    private List<Integer> handBets;

    public BlackjackGame(int betAmount) {
        deck = new Deck();
        playerHands = new ArrayList<>();
        dealerHand = new ArrayList<>();
        handBets = new ArrayList<>();
        isGameOver = false;
        currentHandIndex = 0;

        handBets.add(betAmount);

        List<Card> initialHand = new ArrayList<>();
        initialHand.add(deck.draw());
        initialHand.add(deck.draw());
        playerHands.add(initialHand);

        dealerHand.add(deck.draw());
        dealerHand.add(deck.draw());
    }

    public int calculateScore(List<Card> hand) {
        int score = 0;
        int aces = 0;
        for(Card card : hand) {
            score += card.getValue();
            if(card.getValue() == 11) aces++;
        }
        while(score > 21 && aces > 0) {
            score -= 10;
            aces--;
        }
        return score;
    }

    private void nextHandOrDealer() {
        currentHandIndex++;
        if (currentHandIndex >= playerHands.size()) {
            dealerTurn();
        }
    }

    public void stand() {
        if (!isGameOver) {
            nextHandOrDealer();
        }
    }

    public void doubleDown() {
        if (!isGameOver) {
            List<Card> currentHand = playerHands.get(currentHandIndex);
            if (currentHand.size() == 2) {
                currentHand.add(deck.draw());
                int currentHandBet = handBets.get(currentHandIndex);
                handBets.set(currentHandIndex, currentHandBet * 2);
                nextHandOrDealer();
            }
        }
    }

    public boolean canSplit() {
        if (playerHands.size() == 1 && playerHands.get(0).size() == 2) {
            return playerHands.get(0).get(0).getRank().equals(playerHands.get(0).get(1).getRank());
        }
        return false;
    }

    public void split() {
        if (canSplit()) {
            List<Card> originalHand = playerHands.get(0);
            Card card1 = originalHand.get(0);
            Card card2 = originalHand.get(1);

            List<Card> hand1 = new ArrayList<>();
            hand1.add(card1);
            hand1.add(deck.draw());

            List<Card> hand2 = new ArrayList<>();
            hand2.add(card2);
            hand2.add(deck.draw());

            playerHands.clear();
            playerHands.add(hand1);
            playerHands.add(hand2);

            handBets.add(handBets.get(0));
            currentHandIndex = 0;
        }
    }

    public void playerHit() {
        if (!isGameOver) {
            List<Card> currentHand = playerHands.get(currentHandIndex);
            currentHand.add(deck.draw());
            if (calculateScore(currentHand) > 21) {
                nextHandOrDealer();
            }
        }
    }

    public void dealerTurn() {
        isGameOver = true;
        while (calculateScore(dealerHand) < 17) {
            dealerHand.add(deck.draw());
        }
    }

    public List<String> getResults() {
        List<String> results = new ArrayList<>();
        int dealerScore = calculateScore(dealerHand);

        for (int i = 0; i < playerHands.size(); i++) {
            int playerScore = calculateScore(playerHands.get(i));
            String prefix = playerHands.size() > 1 ? "Hand " + (i + 1) + ": " : "";

            if (playerScore > 21) results.add(prefix + "Verloren (Bust)! Dealer: " + dealerScore);
            else if (dealerScore > 21) results.add(prefix + "Gewonnen (Dealer Bust)! Dealer: " + dealerScore);
            else if (playerScore > dealerScore) results.add(prefix + "Gewonnen! Dealer: " + dealerScore);
            else if (playerScore < dealerScore) results.add(prefix + "Verloren! Dealer: " + dealerScore);
            else results.add(prefix + "Unentschieden! Dealer: " + dealerScore);
        }
        return results;
    }

    public List<List<Card>> getPlayerHands() { return playerHands; }
    public int getCurrentHandIndex() { return currentHandIndex; }
    public List<Card> getDealerHand() { return dealerHand; }
    public boolean isGameOver() { return isGameOver; }
    public List<Integer> getHandBets() { return handBets; }

    public int getCurrentBet() {
        if (currentHandIndex < handBets.size()) {
            return handBets.get(currentHandIndex);
        }
        return handBets.get(0);
    }
}