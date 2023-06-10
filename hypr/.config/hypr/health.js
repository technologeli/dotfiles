import { exec } from 'child_process';

const seconds = (s) => s * 1000;
const minutes = (m) => seconds(m * 60);

const notify = (msg) => exec(`notify-send "${msg}"`);

const posture = setInterval(() => notify("Fix posture"), minutes(10));
const water = setInterval(() => notify("Drink water"), minutes(30));

const work = () => notify("Pomodoro: work time!");
const brk = () => notify("Pomodoro: break time!");

let i = 0;
const startWork = () => {
    work();
    setTimeout(() => {
        i++;
        if (i === 4) {
            i = 0;
            startBreak(30);
        }
        else {
            startBreak(5);
        }
    }, minutes(25));
}

const startBreak = (mins) => {
    brk();
    setTimeout(() => {
        startWork();
    }, minutes(mins));
}

startWork();
