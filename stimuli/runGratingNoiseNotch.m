%%Dr. Ignacio Serrano-Pedraza 11-02-2014
%**********************************************************************************************
%**********************************************************************************************
% Note: this was forked from runGratingNoise() by Ghaith Tarawneh -
% 1/7/2014
function [dump] = runGratingNoiseNotch(expt)

createWindow();

window = getWindow();

[sW, sH] = getResolution();

%% params

temporalFreq = 8; % hz

spatialFreq = 0.04; % cyc/deg

sY = 2/sH;

distance = 7; % viewing distance (cm)

scrPhysicalWidth = 48; % cm

scrPhysicalHeight = 48 / 1.1429 * sY; % cm

SIZE_Y = 2; % texture height (2 pixels for efficient rendering)

NoiseLevel= 5e-3;

media=127.5;
CRMS=0.2;
desv=CRMS*media;

duration = 5; % seconds

direction = -1;

contrast = 0.5;

octaveSetting = 2;

%% unpack expt

if nargin>0
    
    unpackStruct(expt);
    
end

%% body

if octaveSetting<7

    octaves = [0 0.5 1 2 3 4];
    
    rho_min_all = spatialFreq*2.^(-octaves/2);
    
    rho_max_all = spatialFreq*2.^(octaves/2);
    
    rho_min = rho_min_all(octaveSetting);
    
    rho_max = rho_max_all(octaveSetting);
    
    addNoise = 1;

else
    
    rho_min = 0;
    
    rho_max = 0;
    
    addNoise = 0;
    
end

speed = direction * temporalFreq/spatialFreq; % deg/sec

degreesimagex=2*atand(((scrPhysicalWidth/2)/distance));
degreesimagey=2*atand(((scrPhysicalHeight/2)/distance));

gx=degreesimagex/sW;%Degrees of visual angle x
gy=degreesimagey/SIZE_Y;%Degrees of visual angle y

[x,y]=meshgrid(-degreesimagex/2:(degreesimagex/sW):((degreesimagex/2)-(degreesimagex/sW)),((degreesimagey/2)):-(degreesimagey/SIZE_Y):-((degreesimagey/2)-(degreesimagey/SIZE_Y)));
Angulo=0*pi/180;
xx=x.*cos(Angulo)+y.*sin(Angulo);
yy=-x.*sin(Angulo)+y.*cos(Angulo);

fNu=(sW/degreesimagex)/2; %Nyquist frequency axis u
fNv=(SIZE_Y/degreesimagey)/2; %Nyquist frequency axis v

[u,v]=meshgrid(-fNu:(2*fNu/sW):fNu-(2*fNu/sW),fNv:-(2*fNv/SIZE_Y):-(fNv-(2*fNv/SIZE_Y)));

FILTRO1=0.*ones(SIZE_Y,sW);

for i=1:sW
    rho=sqrt(u((SIZE_Y/2)+1,i).^2+v((SIZE_Y/2)+1,i).^2);
    if (rho<=rho_min || rho>=rho_max) && rho<=1.5  %%
        FILTRO1((SIZE_Y/2)+1,i)=1;
    end
    
end

faseC1=pi*ones(1,1);

fps = 60;

frameCount = fps * duration;

textureIndex = nan(frameCount, 1);

for i=1:frameCount
    
    t = i / fps;
   
    ruido=media+desv.*randn(SIZE_Y,sW);
    I=ruido;
    Lave=sum(sum(I.*gx*gy))./(degreesimagex*degreesimagey);
    c=(I-Lave)./Lave;%Contrast function
    FFTimagen=(fftshift(fft2(c)));
    FASEimagen=angle(FFTimagen);
    FFTmodulo=abs(FFTimagen);
    REALPROD=fftshift(FILTRO1.*FFTmodulo.*cos(FASEimagen));
    IMAGPROD=fftshift(FILTRO1.*FFTmodulo.*sin(FASEimagen));
    RESULT=(REALPROD+IMAGPROD*sqrt(-1));
    FINAL=ifft2(RESULT);
    NOISEFILTERED=real(FINAL);
    
    I=NOISEFILTERED;
    Lave=sum(sum(I.*gx*gy))./(degreesimagex*degreesimagey);
    c=(I-Lave)./Lave;%Funcion de contraste
    NORMNOISEFILTERED=127.5*(1+1*(c./max(max(abs(c)))));
    
    luminancias=reshape(NORMNOISEFILTERED,1,sW*SIZE_Y);
    CRMSoriginal=std(luminancias)/mean(luminancias);   %Calculo del Crms AVERAGE NOISE CONTRAST  Stromeyer III & Julesz 1972
    
    frec=sum(FILTRO1((SIZE_Y/2)+1,:))*(1/degreesimagex)/2; %
    Crmsdesired=sqrt(NoiseLevel*2*frec);
    
    m=Crmsdesired/CRMSoriginal;
    I=NORMNOISEFILTERED;
    Lave=sum(sum(I.*gx*gy))./(degreesimagex*degreesimagey);
    c=(I-Lave)./Lave;%
    
    senal=contrast*cos(2*pi*spatialFreq*(xx-speed*t)+faseC1);
    
    imagen=127.5*(1+(senal+addNoise * m*c));
    
%    mxh(i) = max(imagen(:));
%    mnh(i) = min(imagen(:));
    
    %image2=repmat(imagen, [1 1]);
    
    textureIndex(i) = Screen( 'MakeTexture', window, imagen );
    
end

%subplot(2, 1, 1); hist(mxh);
%subplot(2, 1, 2); hist(mnh);

% rendering loop

for i=1:frameCount
    
    Screen('FillRect', window, 0 );
    
    Screen('DrawTexture', window, textureIndex(i), [], [1 1 sW sH] );
    
    Screen('Flip', window);
    
end

% clearing the texture

for i=1:frameCount
    
    Screen('Close', textureIndex(i));
    
end

dump = [];

end