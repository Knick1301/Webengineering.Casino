package util;

import model.User;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.io.*;
import java.util.ArrayList;
import java.util.List;


@WebListener
public class DataHandler implements ServletContextListener {


    private static final String FILE_PATH = System.getProperty("user.home") + File.separator + "casino_users.dat";
    private List<User> userList = new ArrayList<>();

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        File file = new File(FILE_PATH);

        if (file.exists()) {

            try (ObjectInputStream ois = new ObjectInputStream(new FileInputStream(file))) {

                @SuppressWarnings("unchecked")
                List<User> loadedList = (List<User>) ois.readObject();
                userList = loadedList;
                System.out.println("Daten geladen! User-Anzahl: " + userList.size());
            } catch (Exception e) {
                System.out.println("Fehler beim Lesen der Datei!");
                e.printStackTrace();
            }
        } else {

            System.out.println("Keine alte Datei gefunden. Erstelle Test-Account...");
            userList.add(new User(1, "testuser", "geheim123"));
        }


        sce.getServletContext().setAttribute("globalUserList", userList);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {

        try (ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(FILE_PATH))) {
            oos.writeObject(userList);
            System.out.println("User-Daten erfolgreich in Datei gespeichert: " + FILE_PATH);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void saveUserList(List<User> list) {
        try (ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(FILE_PATH))) {
            oos.writeObject(list);
            System.out.println("Neue Registrierung! User-Daten sofort gespeichert.");
        } catch (Exception e) {
            System.out.println("Fehler beim manuellen Speichern:");
            e.printStackTrace();
        }
    }
}