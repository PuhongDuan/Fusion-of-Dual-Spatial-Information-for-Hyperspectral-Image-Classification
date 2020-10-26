function classif=label2colord(label,data_name)

[w h]=size(label);

im=zeros(w,h,3);

switch lower(data_name)
    
    case 'uni'
        map=[192 192 192;0 255 0;0 255 255;0 128 0; 255 0 255;165 82 41;128 0 128;255 0 0;255 255 0];
        for i=1:w
            for j=1:h
                switch(label(i,j))
                    case(1)
                        im(i,j,:)=uint8(map(1,:));
                    case(2)
                        im(i,j,:)=uint8(map(2,:));
                    case(3)
                        im(i,j,:)=uint8(map(3,:));
                    case(4)
                        im(i,j,:)=uint8(map(4,:));
                    case(5)
                        im(i,j,:)=uint8(map(5,:));
                    case(6)
                        im(i,j,:)=uint8(map(6,:));
                    case(7)
                        im(i,j,:)=uint8(map(7,:));
                    case(8)
                        im(i,j,:)=uint8(map(8,:));
                    case(9)
                        im(i,j,:)=uint8(map(9,:));
                end
            end
        end
    case 'center'
        map=[0 0 255;0 128 0;0 255 0;255 0 0;142 71 2;192 192 192;0 255 255;246 110 0; 255 255 0];
        for i=1:w
            for j=1:h
                switch(label(i,j))
                    case(1)
                        im(i,j,:)=uint8(map(1,:));
                    case(2)
                        im(i,j,:)=uint8(map(2,:));
                    case(3)
                        im(i,j,:)=uint8(map(3,:));
                    case(4)
                        im(i,j,:)=uint8(map(4,:));
                    case(5)
                        im(i,j,:)=uint8(map(5,:));
                    case(6)
                        im(i,j,:)=uint8(map(6,:));
                    case(7)
                        im(i,j,:)=uint8(map(7,:));
                    case(8)
                        im(i,j,:)=uint8(map(8,:));
                    case(9)
                        im(i,j,:)=uint8(map(9,:));
                end
            end
        end
        
    case 'india'
%         map=[0 0 255;255 100 0;0 255 134;150 70 150; 100 150 255;60 90 114;255 255 125;255 0 255;100 0 255;1 170 255;0 255 0;175 175 82;100 190 56;140 67 46;115 255 172;255 255 0];
            map=[140 67 46;0 0 255;255 100 0;0 255 123;164 75 155;101 174 255;118 254 172; 60 91 112;255,255,0;255 255 125;255 0 255;100 0 255;0 172 254;0 255 0;171 175 80;101 193 60];
        for i=1:w
            for j=1:h
                switch(label(i,j))
                    case(1)
                        im(i,j,:)=uint8(map(1,:));
                    case(2)
                        im(i,j,:)=uint8(map(2,:));
                    case(3)
                        im(i,j,:)=uint8(map(3,:));
                    case(4)
                        im(i,j,:)=uint8(map(4,:));
                    case(5)
                        im(i,j,:)=uint8(map(5,:));
                    case(6)
                        im(i,j,:)=uint8(map(6,:));
                    case(7)
                        im(i,j,:)=uint8(map(7,:));
                    case(8)
                        im(i,j,:)=uint8(map(8,:));
                    case(9)
                        im(i,j,:)=uint8(map(9,:));
                    case(10)
                        im(i,j,:)=uint8(map(10,:));
                    case(11)
                        im(i,j,:)=uint8(map(11,:));
                    case(12)
                        im(i,j,:)=uint8(map(12,:));
                    case(13)
                        im(i,j,:)=uint8(map(13,:));
                    case(14)
                        im(i,j,:)=uint8(map(14,:));   
                    case(15)
                        im(i,j,:)=uint8(map(15,:));   
                    case(16)
                        im(i,j,:)=uint8(map(16,:));   
                end
            end
        end
    case 'dc'
        map=[204 102 102;153 51 0;204 153 0;0 255 0; 0 102 0;0 51 255;153 153 153];
        for i=1:w
            for j=1:h
                switch(label(i,j))
                    case(1)
                        im(i,j,:)=uint8(map(1,:));
                    case(2)
                        im(i,j,:)=uint8(map(2,:));
                    case(3)
                        im(i,j,:)=uint8(map(3,:));
                    case(4)
                        im(i,j,:)=uint8(map(4,:));
                    case(5)
                        im(i,j,:)=uint8(map(5,:));
                    case(6)
                        im(i,j,:)=uint8(map(6,:));
                    case(7)
                        im(i,j,:)=uint8(map(7,:));
                end
            end
        end
            case 'cloud'
        map=[255 0 0;0 0 255];
        for i=1:w 
            for j=1:h
                switch(label(i,j))
                    case(1)
                        im(i,j,:)=uint8(map(1,:));
                    case(2)
                        im(i,j,:)=uint8(map(2,:));
                end
            end
        end
        
      case 'houston'
%             map=[0, 205, 0;127, 255, 0;46, 139, 87;0, 139, 0;160, 82, 45;0, 255, 255;255, 255, 255; 216, 191, 216;255, 0, 0;139, 0, 0;0, 0, 0;255, 255, 0;238, 154, 0;85, 26, 139;255, 127, 80];
            map=[0,183,0;0,123,0;0,138,70;0,69,0;169,121,10;0,185,190;120,0,0;217,217,248;120,120,120;200,170,120;220,180,130;96,96,96;184,177,96;0,240,0;203,17,54];
        for i=1:w
            for j=1:h
                switch(label(i,j))
                    case(1)
                        im(i,j,:)=uint8(map(1,:));
                    case(2)
                        im(i,j,:)=uint8(map(2,:));
                    case(3)
                        im(i,j,:)=uint8(map(3,:));
                    case(4)
                        im(i,j,:)=uint8(map(4,:));
                    case(5)
                        im(i,j,:)=uint8(map(5,:));
                    case(6)
                        im(i,j,:)=uint8(map(6,:));
                    case(7)
                        im(i,j,:)=uint8(map(7,:));
                    case(8)
                        im(i,j,:)=uint8(map(8,:));
                    case(9)
                        im(i,j,:)=uint8(map(9,:));
                    case(10)
                        im(i,j,:)=uint8(map(10,:));
                    case(11)
                        im(i,j,:)=uint8(map(11,:));
                    case(12)
                        im(i,j,:)=uint8(map(12,:));
                    case(13)
                        im(i,j,:)=uint8(map(13,:));
                    case(14)
                        im(i,j,:)=uint8(map(14,:));   
                    case(15)
                        im(i,j,:)=uint8(map(15,:));   
                end
            end
        end

  case 'tn'
        map=[192 192 192;0 255 0;0 255 255;0 128 0; 255 0 255;165 82 41];
        for i=1:w
            for j=1:h
                switch(label(i,j))
                    case(1)
                        im(i,j,:)=uint8(map(1,:));
                    case(2)
                        im(i,j,:)=uint8(map(2,:));
                    case(3)
                        im(i,j,:)=uint8(map(3,:));
                    case(4)
                        im(i,j,:)=uint8(map(4,:));
                    case(5)
                        im(i,j,:)=uint8(map(5,:));
                    case(6)
                        im(i,j,:)=uint8(map(6,:));
                end
            end
        end  
        case 'hu'
%         map=[0 0 255;255 100 0;0 255 134;150 70 150; 100 150 255;60 90 114;255 255 125;255 0 255;100 0 255;1 170 255;0 255 0;175 175 82;100 190 56;140 67 46;115 255 172;255 255 0];
%             map=[140 67 46;0 0 255;255 100 0;0 255 123;164 75 155;101 174 255;118 254 172; 60 91 112;255,255,0;255 255 125;255 0 255;100 0 255;0 172 254;0 255 0;171 175 80;101 193 60;100 150 30; 200 230 100; 250 100 0; 100 200 88];
%             map=[0 255 0;160, 255, 0;46 139 87; 0 139 0; 0 70 0;160 82 45;0 255 255; 255 255 255;216 191 216;255 0 0;170 160 150;127 127 127;160 0 0;80,0,0;255,160,60;255 255 0;237 153 0;255 0 255;0 0 255;175 195 221];
            map=[0, 205, 0;127, 255, 0;46, 139, 87;0, 139, 0;0, 70, 0;160, 82, 45;0, 255, 255;255, 255, 255;216, 191, 216; 255, 0, 0;170, 160, 150; 128, 128, 128;160, 0, 0;80, 0, 0; 232, 161, 24;255, 255, 0;238, 154, 0;255, 0, 255; 0, 0, 255;176, 196, 222];
        for i=1:w
            for j=1:h
                switch(label(i,j))
                    case(1)
                        im(i,j,:)=uint8(map(1,:));
                    case(2)
                        im(i,j,:)=uint8(map(2,:));
                    case(3)
                        im(i,j,:)=uint8(map(3,:));
                    case(4)
                        im(i,j,:)=uint8(map(4,:));
                    case(5)
                        im(i,j,:)=uint8(map(5,:));
                    case(6)
                        im(i,j,:)=uint8(map(6,:));
                    case(7)
                        im(i,j,:)=uint8(map(7,:));
                    case(8)
                        im(i,j,:)=uint8(map(8,:));
                    case(9)
                        im(i,j,:)=uint8(map(9,:));
                    case(10)
                        im(i,j,:)=uint8(map(10,:));
                    case(11)
                        im(i,j,:)=uint8(map(11,:));
                    case(12)
                        im(i,j,:)=uint8(map(12,:));
                    case(13)
                        im(i,j,:)=uint8(map(13,:));
                    case(14)
                        im(i,j,:)=uint8(map(14,:));   
                    case(15)
                        im(i,j,:)=uint8(map(15,:));   
                    case(16)
                        im(i,j,:)=uint8(map(16,:));   
                    case(17)
                        im(i,j,:)=uint8(map(17,:));   
                    case(18)
                        im(i,j,:)=uint8(map(18,:));   
                    case(19)
                        im(i,j,:)=uint8(map(19,:)); 
                    case(20)
                        im(i,j,:)=uint8(map(20,:)); 
                end
            end
        end
        case 'hsi'
%         map=[0 0 255;255 100 0;0 255 134;150 70 150; 100 150 255;60 90 114;255 255 125;255 0 255;100 0 255;1 170 255;0 255 0;175 175 82;100 190 56;140 67 46;115 255 172;255 255 0];100 190 56
            map=[140 67 46;0 0 255;255 100 0;0 255 123;164 75 155;101 174 255;118 254 172; 60 91 112;216,191,216;255 255 125;255 0 255;100 0 255;0 172 254;0 255 0;171 175 80;101 193 60;0 51 200;0 102 0;115 255 172;0 255 255];
        for i=1:w
            for j=1:h
                switch(label(i,j))
                    case(1)
                        im(i,j,:)=uint8(map(1,:));
                    case(2)
                        im(i,j,:)=uint8(map(2,:));
                    case(3)
                        im(i,j,:)=uint8(map(3,:));
                    case(4)
                        im(i,j,:)=uint8(map(4,:));
                    case(5)
                        im(i,j,:)=uint8(map(5,:));
                    case(6)
                        im(i,j,:)=uint8(map(6,:));
                    case(7)
                        im(i,j,:)=uint8(map(7,:));
                    case(8)
                        im(i,j,:)=uint8(map(8,:));
                    case(9)
                        im(i,j,:)=uint8(map(9,:));
                    case(10)
                        im(i,j,:)=uint8(map(10,:));
                    case(11)
                        im(i,j,:)=uint8(map(11,:));
                    case(12)
                        im(i,j,:)=uint8(map(12,:));
                    case(13)
                        im(i,j,:)=uint8(map(13,:));
                    case(14)
                        im(i,j,:)=uint8(map(14,:));   
                    case(15)
                        im(i,j,:)=uint8(map(15,:));   
                    case(16)
                        im(i,j,:)=uint8(map(16,:));   
                     case(17)
                        im(i,j,:)=uint8(map(17,:));
                    case(18)
                        im(i,j,:)=uint8(map(18,:));   
                    case(19)
                        im(i,j,:)=uint8(map(19,:));   
                    case(20)
                        im(i,j,:)=uint8(map(20,:)); 
                end
            end
        end
case 'oil'
        map=[0 0 0;0 0 127];
        for i=1:w
            for j=1:h
                switch(label(i,j))
                    case(1)
                        im(i,j,:)=uint8(map(1,:));
                    case(2)
                        im(i,j,:)=uint8(map(2,:));
                end
            end
        end
   case 'cloud'
        map=[255 0 0;0 0 255];
        for i=1:w
            for j=1:h
                switch(label(i,j))
                    case(1)
                        im(i,j,:)=uint8(map(1,:));
                    case(2)
                        im(i,j,:)=uint8(map(2,:));
                end
            end
        end  
case 'min'
        map=[0,255,0;255,255,0;255,0,255;46,139,87;255,127,80;127,255,212];
        for i=1:w
            for j=1:h
                switch(label(i,j))
                    case(1)
                        im(i,j,:)=uint8(map(1,:));
                    case(2)
                        im(i,j,:)=uint8(map(2,:));
                    case(3)
                        im(i,j,:)=uint8(map(3,:));
                    case(4)
                        im(i,j,:)=uint8(map(4,:));
                    case(5)
                        im(i,j,:)=uint8(map(5,:));
                    case(6)
                        im(i,j,:)=uint8(map(6,:));
                end
            end
        end
     case 'mine'
        map=[152,251,152;245,222,179;139,69,19;34,139,34;255,201,14];
        for i=1:w
            for j=1:h
                switch(label(i,j))
                    case(1)
                        im(i,j,:)=uint8(map(1,:));
                    case(2)
                        im(i,j,:)=uint8(map(2,:));
                    case(3)
                        im(i,j,:)=uint8(map(3,:));
                    case(4)
                        im(i,j,:)=uint8(map(4,:));
                    case(5)
                        im(i,j,:)=uint8(map(5,:));
                    case(6)
                        im(i,j,:)=uint8(map(6,:));
                end
            end
        end  
case 'yr'
%         map=[0,255,0;0,125,0;0,122,255;43,173,151;143,246,189;255,149,154;206,208,206;255,255,255];
          map=[160,255,116;0,125,0;0,122,255;43,173,151;143,246,189;255,149,154;206,208,206;248,170,10];
        for i=1:w
            for j=1:h
                switch(label(i,j))
                    case(1)
                        im(i,j,:)=uint8(map(1,:));
                    case(2)
                        im(i,j,:)=uint8(map(2,:));
                    case(3)
                        im(i,j,:)=uint8(map(3,:));
                    case(4)
                        im(i,j,:)=uint8(map(4,:));
                    case(5)
                        im(i,j,:)=uint8(map(5,:));
                    case(6)
                        im(i,j,:)=uint8(map(6,:));
                    case(7)
                        im(i,j,:)=uint8(map(7,:));
                    case(8)
                        im(i,j,:)=uint8(map(8,:));
                end
            end
        end
end

name=sprintf('classif_%s.tif',data_name);
im=uint8(im);
classif=uint8(zeros(w,h,3));
classif(:,:,1)=im(:,:,1);
classif(:,:,2)=im(:,:,2);
classif(:,:,3)=im(:,:,3);
%imwrite(classif,name);