---
layout:     default
title:      "SuperCollider"
date:       2014-07-15
editdate:   2020-05-11
categories: Music
disqus_id:  supercollider.html
render_with_liquid: false
---

### SuperCollider examples

These are [SuperCollider](http://supercollider.sourceforge.net) lecture notes on the topic of music and math.

[Download notes](../blog/20140714_supercollider/class.scd).

The notes:

    s.boot

    // Pure sine wave

    {SinOsc.ar(440)}.play

    // HINT: to see the wave, change “play” to "plot"

    {SinOsc.ar(100)}.plot

    // or to specify the range

    {SinOsc.ar(100)}.plot(0.02)

    // Amplitude change

    {SinOsc.ar(440)*0.5}.play
    {SinOsc.ar(440)*0.5}.plot

    // Frequency change

    {SinOsc.ar(440*0.5)}.play
    {SinOsc.ar(440*0.5)}.plot

    // Sawtooth wave

    {LFSaw.ar(440)}.play
    {LFSaw.ar(440)}.plot

    // Triangle wave

    {LFTri.ar(440)}.play
    {LFTri.ar(440)}.plot

    // Square

    {LFPulse.ar(440)}.play
    {LFPulse.ar(440)}.plot

    // Making a square wave with sine waves (Change play to plot to see how accurate it is!)

    (
    var numSines = 7;
    {
         ({arg i;
                 var j = i * 2 + 1; // the odd harmonics (1,3,5,7,etc)
                 SinOsc.ar(440 * j, 0, 1/j)
         } ! numSines).sum;
    }.play;
    )

    // Noise

    {LFNoise0.ar(440)}.play
    {LFNoise0.ar(440)}.plot(0.25)

    // All of the audible frequencies

    {LFPulse.ar(MouseX.kr(1,30))}.play
    {SinOsc.ar(MouseX.kr(20,17000))}.play

    // Wave addition

    {SinOsc.ar(MouseX.kr(220,440))+SinOsc.ar(MouseY.kr(220,440))}.play

    {SinOsc.ar(220)}.plot
    {SinOsc.ar(220)+SinOsc.ar(330)}.plot
    {SinOsc.ar(220)+SinOsc.ar(440)}.plot
    {SinOsc.ar(220)+SinOsc.ar(660)}.plot

    {SinOsc.ar(440)}.play
    {SinOsc.ar(435)+SinOsc.ar(445)}.play
    {SinOsc.ar(435)+SinOsc.ar(445)}.plot(0.2)

    // Harmonic overtones

    {SinOsc.ar(440)}.play
    {SinOsc.ar(440*2)}.play
    {SinOsc.ar(440*3)}.play
    {SinOsc.ar(440*4)}.play
    {SinOsc.ar(440*5)}.play
    {SinOsc.ar(440*6)}.play
    {SinOsc.ar(440*7)}.play
    {SinOsc.ar(440*8)}.play
    {SinOsc.ar(440*9)}.play
    {SinOsc.ar(440*10)}.play

    // Vary even vs odd harmonics with mouse (change play to plot!)

    ({
        var odd, even;
        odd = SinOsc.ar(440*3)+
        SinOsc.ar(440*5)+
        SinOsc.ar(440*7)+
        SinOsc.ar(440*7)+
        SinOsc.ar(440*9)*MouseY.kr(0,1);
        even = SinOsc.ar(440*2)+
        SinOsc.ar(440*4)+
        SinOsc.ar(440*6)+
        SinOsc.ar(440*7)+
        SinOsc.ar(440*8)*MouseX.kr(0,1);
        SinOsc.ar(440) + even + odd
    }.play)

    // Specify the loudness of each harmonic

    ({
        a = SinOsc.ar(440);
        b = SinOsc.ar(440*2)*0.01;
        c = SinOsc.ar(440*3)*0.06;
        d = SinOsc.ar(440*4)*0.04;
        e = SinOsc.ar(440*5)*0.15;
        f = SinOsc.ar(440*6)*0.07;
        g = SinOsc.ar(440*7)*0.05;
        h = SinOsc.ar(440*8)*0.08;
        i = SinOsc.ar(440*9)*0.01;
        j = SinOsc.ar(440*10)*0.02;
        k = SinOsc.ar(440*11)*0.01;
        a+b+c+d+e+f+g+h+i+j+k;
    }.play)

    // Using ratios to get a scale

    // A
    {SinOsc.ar(440*1/2)}.play

    // D (above middle C)
    {SinOsc.ar(440*2/3)}.play

    // E
    {SinOsc.ar(440*3/4)}.play

    // A
    {SinOsc.ar(440)}.play

    // An “equal tempered” major scale (close to not exactly the same as the harmonic intervals)

    (
    var scale, buffer;
    scale = FloatArray[0, 2, 4, 5, 7, 9, 11]; // major scale
    buffer = Buffer.alloc(s, scale.size,1, {|b| b.setnMsg(0, scale) });
    {SinOsc.ar((DegreeToKey.kr(buffer.bufnum,MouseX.kr(0,15),12,1,72)).midicps,0,0.1);}.play
    )

    // Amplitude modulation (AM) TURN THE VOLUME DOWN!

    (
    {
        var amplitude, signal;
        amplitude = SinOsc.kr(MouseX.kr(0,50)).range(0,50);
        signal = SinOsc.ar(440)*amplitude;
    }.play
    )

    // Frequency modulation (FM)

    (
    {
        var frequency, signal;
        frequency = SinOsc.kr(MouseX.kr(0,250)).range(0,250);
        signal = SinOsc.ar(frequency);
    }.play
    )

    // FUN STUFF

    // ---------------------------------
    // Random pitches

    {SinOsc.ar(LFNoise0.kr(MouseX.kr(3,100)).range(200,1000));}.play

    // ---------------------------------
    // Repeating pitches

    play{SinOsc.ar(OnePole.ar(Mix(LFSaw.ar([1,0.99],[0,0.6],1000,2000).trunc([400,600])*[1,-1]),0.98)).dup*0.1}

    // ---------------------------------
    // Bubbles
    (
    {
        (
            {
                RHPF.ar(
                    OnePole.ar(BrownNoise.ar, 0.99),
                    LPF.ar(BrownNoise.ar, 14) * 400 + 500, 0.03, 0.003)}!2
        )
        +
        (
            {
                RHPF.ar(
                    OnePole.ar(BrownNoise.ar, 0.99),
                    LPF.ar(BrownNoise.ar, 20) * 800 + 500, 0.03, 0.005)}!2
        ) * 4
    }.play
    )




    // Super Mario
    // http://www.youtube.com/watch?v=mnipB_8Br8U&app=desktop




    // ---------------------------------
    // Space Music
    (
    // modal space
    // mouse x controls discrete pitch in dorian mode
    var scale, buffer;
    //scale = FloatArray[0, 2, 3.2, 5, 7, 9, 10]; // dorian scale
    //scale = FloatArray[0, 2, 4, 6, 7, 9, 11];
    scale = FloatArray[0, 2, 4, 6, 8, 10]; // whole tone
    scale = FloatArray[0, 1, 3, 4, 6, 7, 9, 10]; //
    buffer = Buffer.alloc(s, scale.size,1, {|b| b.setnMsg(0, scale) });
    {
        var mix;
        mix =

        // drone 5ths
        RLPF.ar(LFPulse.ar([48,55].midicps, 0.15),
            SinOsc.kr(0.1, 0, 10, 72).midicps, 0.1, 0.1) * MouseY.kr(0,0.5) +
        // lead tone
        SinOsc.ar(
            (
                DegreeToKey.kr(
                    buffer.bufnum,
                    MouseX.kr(0,15),        // mouse indexes into scale
                    12,                    // 12 notes per octave
                    1,                    // mul = 1
                    72                    // offset by 72 notes
                )
                + LFNoise1.kr([3,3], 0.04)    // add some low freq stereo detuning
            ).midicps,                        // convert midi notes to hertz
            0,
            0.1) * (0.15+MouseY.kr(0,0.2));


        // add some 70's euro-space-rock echo
        CombN.ar(mix, 0.31, 0.31, 2, 1, mix)
    }.play
    )

    (
    s = Server.local.boot;
    s.waitForBoot{ Routine {
    /// in a "real" patch, i'd make these local variables,
    /// but in testing its convenient to use environment variables.
    // var inst, tclock, score, playr, switchr;

    // the current instrument
    ~inst = \ding;
    // a fast TempoClock
    ~tclock = TempoClock.new(8);

    // two instruments that take the same arguments
    SynthDef.new(\ding, {
        arg dur=0.2, hz=880, out=0, level=0.25, pan=0.0;
        var snd;
        var amp = EnvGen.ar(Env.perc, doneAction:2, timeScale:dur);
        snd = SinOsc.ar(hz) * amp * level;
        Out.ar(out, Pan2.ar(snd, pan));
    }).send(s);

    SynthDef.new(\tick, {
        arg dur=0.1, hz=880, out=0, level=0.25, pan=0.0;
        var snd;
        var amp = EnvGen.ar(Env.perc, doneAction:2, timeScale:dur);
        snd = LPF.ar(WhiteNoise.ar, hz) * amp * level;
        Out.ar(out, Pan2.ar(snd, pan));
    }).send(s);

    s.sync;

    // the "score" is just a nested array of argument values
    // there are also many kinds of associative collections in SC if you prefer
    ~score = [
        // each entry:
        // midi note offset, note duration in seconds, wait time in beats
        [0, 0.4, 2],
        [3, 0.4, 1],
        [1, 0.2, 1],
        [4, 0.2, 1],
        [7, 0.15, 1],
        [6, 0.5, 2],
        [9, 0.1, 1],
        [10, 0.3, 1]

    ];

    //0, 1, 3, 4, 6, 7, 9, 10
    // a routine that plays the score, not knowing which instrument is the target
    ~playr = Routine { var note, hz; inf.do({ arg i;
        // get the next note
        note = ~score.wrapAt(i);
        // interpret scale degree as MIDI note plus offset
        hz = (note[0] + 60).midicps;
        // play the note
        Synth.new(~inst, [\hz, hz, \dur, note[1] ], s);
        // wait
        note[2].wait;
    }); }.play(~tclock);


    // a routine that randomly switches instruments
    ~switchr = Routine { var note, hz; inf.do({ arg i;
        if(0.2.coin, {
            if(~inst == \ding, {
                ~inst = \tick;
            }, {
                ~inst = \ding;
            });
            ~inst.postln;
        });
        // wait
        1.wait;
    }); }.play(~tclock);

    }.play; };
    )
