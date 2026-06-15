

import javax.swing.*;
import java.awt.*;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;

public class ClickRectFiller extends JFrame {

    public ClickRectFiller() {
        setTitle("Shape Exercise");
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setSize(360, 180);
        setLocationRelativeTo(null);

        add(new RectComponent());

        setVisible(true);
    }

    private class RectComponent extends JComponent {
        private final Rectangle[] rects;
        private final Color[] colors;
        private int activeIndex = -1;

        public RectComponent() {
            rects = new Rectangle[3];
            int y = 30;
            int width = 80;
            int height = 50;

            rects[0] = new Rectangle(30, y, width, height);
            rects[1] = new Rectangle(130, y, width, height);
            rects[2] = new Rectangle(230, y, width, height);

            colors = new Color[]{Color.RED, Color.GREEN, Color.BLUE};

            addMouseListener(new MouseAdapter() {
                @Override
                public void mousePressed(MouseEvent e) {
                    boolean clickedInside = false;

                    for (int i = 0; i < rects.length; i++) {
                        if (rects[i].contains(e.getPoint())) {
                            activeIndex = i;
                            clickedInside = true;
                            break;
                        }
                    }

                    if (!clickedInside) {
                        activeIndex = -1;
                    }

                    repaint();
                }
            });
        }

        @Override
        protected void paintComponent(Graphics g) {
            super.paintComponent(g);

            Graphics2D g2d = (Graphics2D) g;

            for (int i = 0; i < rects.length; i++) {
                if (i == activeIndex) {
                    g2d.setColor(colors[i]);
                    g2d.fill(rects[i]);
                }

                g2d.setColor(Color.BLACK);
                g2d.draw(rects[i]);
            }
        }
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> new ClickRectFiller());
    }
}