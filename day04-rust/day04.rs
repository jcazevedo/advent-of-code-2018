use std::collections::HashMap;
use std::fs::File;
use std::io::BufReader;
use std::io::prelude::*;

struct SleepInterval {
    start: i32,
    end: i32
}

struct Guard {
    id: i32,
    intervals: Vec<SleepInterval>
}

fn interval_length(interval: &SleepInterval) -> i32 {
    interval.end - interval.start
}

fn minutes_asleep(guard: &Guard) -> i32 {
    guard.intervals.iter().fold(0, |acc, i| acc + interval_length(i))
}

fn minutes_frequency(guard: &Guard) -> HashMap<i32, i32> {
    let mut minutes = HashMap::new();
    for i in &guard.intervals {
        for m in i.start..i.end {
            let min = minutes.entry(m).or_insert(0);
            *min += 1;
        }
    }
    minutes
}

fn minute_most_time_asleep(guard: &Guard) -> Option<i32> {
    let minutes = minutes_frequency(guard);
    let mut best = None;
    for (k, v) in &minutes {
        match best {
            None => best = Some(*k),
            Some(curr) => if v > minutes.get(&curr).unwrap() { best = Some(*k) }
        }
    }
    best
}

fn most_frequent_minute(guard: &Guard) -> Option<(i32, i32)> {
    let minutes = minutes_frequency(guard);
    let mut best = None;
    for (k, v) in &minutes {
        match best {
            None => best = Some((*k, *v)),
            Some((_, f)) => if v > &f { best = Some((*k, *v)) }
        }
    }
    best
}

fn lines_from_file(filename: &str) -> Vec<String> {
    let file = File::open(filename).unwrap();
    let buf = BufReader::new(file);
    buf.lines().map(|l| l.unwrap()).collect()
}

fn main() {
    let mut lines = lines_from_file("04.input");
    lines.sort();
    let mut guards = HashMap::new();
    let mut current_guard = 0;
    let mut start = 0;
    for l in &lines {
        let splits = l.split(" ").collect::<Vec<&str>>();
        if splits[2] == "Guard" {
            current_guard = splits[3].to_string()[1..].parse::<i32>().unwrap()
        } else {
            let times = splits[1][..5].split(":").collect::<Vec<&str>>();
            let time = times[0].parse::<i32>().unwrap() * 60 + times[1].parse::<i32>().unwrap();
            if splits[2] == "falls" {
                start = time
            } else {
                let guard = guards.entry(current_guard).or_insert(Guard { id: current_guard, intervals: Vec::new() });
                (*guard).intervals.push(SleepInterval { start: start, end: time });
            }
        }
    }
    let sleepy_guard = guards.values().max_by_key(|g| minutes_asleep(g)).unwrap();
    let frequent_guard = guards.values().max_by_key(|g| most_frequent_minute(g).unwrap().1).unwrap();
    println!("Part 1: {}", minute_most_time_asleep(sleepy_guard).unwrap() * sleepy_guard.id);
    println!("Part 2: {}", most_frequent_minute(frequent_guard).unwrap().0 * frequent_guard.id);
}
