function [SamplesY] = ToInt16(SamplesY,FileName)

SamplesY  =  int16(SamplesY);

S = FileName;

fp = fopen(FileName,'wt');
    
    for i =1 : length(SamplesY)

        fprintf(fp, '%d\n', real(SamplesY(i)));
        fprintf(fp, '%d\n', imag(SamplesY(i)));

    end

fclose(fp);


end

