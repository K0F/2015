

s.boot;




(
    p=ProxySpace.push(s.reboot);
    e=ProxySubmix.new(\filter);
);

s.reboot;

(

    SynthDef(\fx, {arg out = 0, in, trig = 0, lag = 0.1, grid = 1/2, bit = 7, sample = 5000;
                   var sig, del;
                   sig = In.ar(in,2)*0.5 + Select.ar(trig, [In.ar(in, 2)*0.5, LocalIn.ar(2), LPF.ar(Decimator.ar(In.ar(in,2)*0.5, sample, bit), 6000)]);
                   del = DelayL.ar(sig, 1.0, Lag.kr(grid, lag));
                   LocalOut.ar(HPF.ar(del*(trig.clip(0, 1)), 2000));
                   Out.ar(out, Pan2.ar(sig[0], TRand.kr(-0.5, 0.5, trig)*trig));
                  }).add;

)

(
    ~rep = Bus.audio(s, 2);

    Pmono(\fx, *[\trig : Pwrand([0, 1, 2], [0.4, 0.3, 0.3], inf),
                 \grid: Prand([1/2, 1/4, 1/8, 1/16], inf),
                 \bit: Prand([7, 10, 8, 24], inf),
                 \sample: Pwhite(1000, 10100, inf),
                 \lag: Pwhite(0, 0.1, inf),
                 \in: ~rep,
                 \dur: 1/8]).play(quant: 4);

)
