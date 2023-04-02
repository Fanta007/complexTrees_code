function Pr = rot3d(P,origin,dirct,theta)
% �������P���ţ���origin�㣬����Ϊdirct��ֱ�ߣ���תtheta��
% P����Ҫ��ת�����꼯�ϣ�n��3����
% origin��ת��ͨ���ĵ㣬1��3����
% direct��ת�᷽��������1��3����
% theta����ת�Ƕȣ���λ����
%
% By LaterComer of MATLAB������̳
% See also http://www.matlabsky.com
% Contact me matlabsky@gmail.com
% Modifid at 2011-07-26 19:51:32

    dirct=dirct(:)/(norm(dirct)+1e-5);

    A_hat=dirct*dirct';

    A_star=[0,         -dirct(3),      dirct(2)
            dirct(3),          0,     -dirct(1)
           -dirct(2),   dirct(1),            0];
    I=eye(3);
    M=A_hat+cos(theta)*(I-A_hat)+sin(theta)*A_star;
    origin=repmat(origin(:)',size(P,1),1);
    Pr=(P-origin)*M'+origin;
end
