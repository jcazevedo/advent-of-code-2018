import java.io.*;
import java.util.*;

public class day24 {
    public static class Group {
        public int id;
        public int nUnits;
        public int hitPoints;
        public Set<String> weaknesses;
        public Set<String> immunities;
        public int damageValue;
        public String damageType;
        public int initiative;
        public String type;

        public int effectivePower() {
            return nUnits * damageValue;
        }

        public int damageTo(Group g) {
            if (g.immunities.contains(damageType))
                return 0;
            if (g.weaknesses.contains(damageType))
                return 2 * effectivePower();
            return effectivePower();
        }
    }

    public static class EffectivePowerComparator implements Comparator<Group> {
        public int compare(Group g1, Group g2) {
            int v1 = g2.effectivePower() - g1.effectivePower();
            if (v1 == 0)
                return g2.initiative - g1.initiative;
            return v1;
        }
    }

    public static class InitativeComparator implements Comparator<Group> {
        public int compare(Group g1, Group g2) {
            return g2.initiative - g1.initiative;
        }
    }

    public static int unitsInWinningArmy(List<Group> immuneSystem, List<Group> infection) {
        int immTotal = 0;
        int infTotal = 0;
        List<Group> allGroups = new ArrayList<Group>();
        for (Group g : immuneSystem) {
            immTotal += g.nUnits;
            allGroups.add(g);
        }
        for (Group g : infection) {
            infTotal += g.nUnits;
            allGroups.add(g);
        }
        if (immTotal == 0)
            return infTotal;
        if (infTotal == 0)
            return immTotal;

        Map<Group, Group> attacks = new HashMap<Group, Group>();
        Set<Group> beingAttacked = new HashSet<Group>();

        Collections.sort(allGroups, new EffectivePowerComparator());

        for (Group g1 : allGroups) {
            Group target = null;
            for (Group g2 : allGroups) {
                if (g1.type == g2.type || beingAttacked.contains(g2) || g1.damageTo(g2) == 0)
                    continue;

                if (target == null || g1.damageTo(g2) > g1.damageTo(target)) {
                        target = g2;
                } else if (target != null && g1.damageTo(g2) == g1.damageTo(target)) {
                    if (g2.effectivePower() > target.effectivePower())
                        target = g2;
                    else if (g2.effectivePower() == target.effectivePower() && g2.initiative > target.initiative)
                        target = g2;
                }
            }
            if (target != null) {
                attacks.put(g1, target);
                beingAttacked.add(target);
            }
        }

        Collections.sort(allGroups, new InitativeComparator());

        for (Group g : allGroups) {
            Group target = attacks.get(g);
            if (g.nUnits > 0 && target != null) {
                int damage = g.damageTo(target);
                target.nUnits -= (damage / target.hitPoints);
                if (target.nUnits < 0)
                    target.nUnits = 0;
            }
        }

        for (Iterator<Group> iter = immuneSystem.iterator(); iter.hasNext(); ) {
            Group g = iter.next();
            if (g.nUnits <= 0)
                iter.remove();
        }

        for (Iterator<Group> iter = infection.iterator(); iter.hasNext(); ) {
            Group g = iter.next();
            if (g.nUnits <= 0)
                iter.remove();
        }

        return unitsInWinningArmy(immuneSystem, infection);
    }

    public static void main(String[] args) {
        try {
            File file = new File("24.input");
            BufferedReader br = new BufferedReader(new FileReader(file));
            String line;
            String type = null;
            List<Group> immuneSystem = new ArrayList<Group>();
            List<Group> infection = new ArrayList<Group>();
            List<Group> current = null;
            int id= 0;
            while ((line = br.readLine()) != null) {
                if (line.startsWith("Immune System")) {
                    current = immuneSystem;
                    type = "immune";
                    id = 0;
                } else if (line.startsWith("Infection")) {
                    current = infection;
                    type = "infection";
                    id = 0;
                } else if (line.length() > 0) {
                    id++;
                    Group g = new Group();
                    g.id = id;
                    g.type = type;
                    String[] splits = line.split("\\s+");
                    g.nUnits = Integer.parseInt(splits[0]);
                    g.hitPoints = Integer.parseInt(splits[4]);
                    g.weaknesses = new HashSet<String>();
                    g.immunities = new HashSet<String>();
                    int p = line.indexOf('(');
                    if (p != -1) {
                        String tmp = line.substring(p + 1, line.indexOf(')'));
                        String[] wisplits = tmp.split("; ");
                        for (int i = 0; i < wisplits.length; i++) {
                            String s = wisplits[i];
                            Set<String> set = null;
                            if (s.startsWith("immune to")) {
                                s = s.substring("immune to ".length());
                                set = g.immunities;
                            } else if (s.startsWith("weak to")) {
                                s = s.substring("weak to ".length());
                                set = g.weaknesses;
                            }
                            String[] values = s.split(", ");
                            for (int j = 0; j < values.length; j++) {
                                set.add(values[j]);
                            }
                        }
                    }
                    g.initiative = Integer.parseInt(splits[splits.length - 1]);
                    g.damageType = splits[splits.length - 5];
                    g.damageValue = Integer.parseInt(splits[splits.length - 6]);
                    current.add(g);
                }
            }

            System.out.println("Part 1: " + unitsInWinningArmy(immuneSystem, infection));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
