package slot;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

public class SlotMachine {

    private static final String[] SYMBOLS = {"🍒", "🍋", "🍊", "🔔", "💎", "7️⃣", "🍉", "🍇", "⭐", "🍀"};

    private List<String> currentReels;
    private int betAmount;
    private int payout;
    private String resultMessage;

    public SlotMachine(int betAmount) {
        this.betAmount = betAmount;
        this.currentReels = new ArrayList<>();
        this.payout = 0;
        this.resultMessage = "";
    }

    public void spin() {
        Random random = new Random();
        currentReels.clear();

        for (int i = 0; i < 4; i++) {
            currentReels.add(SYMBOLS[random.nextInt(SYMBOLS.length)]);
        }

        calculatePayout();
    }

    private void calculatePayout() {
        Map<String, Integer> counts = new HashMap<>();
        for (String s : currentReels) {
            counts.put(s, counts.getOrDefault(s, 0) + 1);
        }

        int maxMatches = 0;
        String bestSymbol = "";
        for (Map.Entry<String, Integer> entry : counts.entrySet()) {
            if (entry.getValue() > maxMatches) {
                maxMatches = entry.getValue();
                bestSymbol = entry.getKey();
            }
        }

        if (maxMatches == 4) {
            if (bestSymbol.equals("7️⃣")) {
                payout = betAmount * 200;
                resultMessage = "MEGA JACKPOT! 4x Sieben!";
            } else if (bestSymbol.equals("💎")) {
                payout = betAmount * 100;
                resultMessage = "Wahnsinn! 4x Diamant!";
            } else {
                payout = betAmount * 40;
                resultMessage = "Super Gewinn! 4 Gleiche!";
            }
        } else if (maxMatches == 3) {
            payout = betAmount * 5;
            resultMessage = "Toll! 3 Gleiche!";
        } else if (maxMatches == 2) {
            payout = betAmount;
            resultMessage = "Kleiner Gewinn! 2 Gleiche!";
        } else {
            payout = 0;
            resultMessage = "Leider nichts. Versuch es nochmal!";
        }
    }

    public List<String> getCurrentReels() { return currentReels; }
    public int getPayout() { return payout; }
    public String getResultMessage() { return resultMessage; }
    public int getBetAmount() { return betAmount; }
}