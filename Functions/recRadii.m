function Radius = recRadii(T)


Radius.len0 = T.len0;
Radius.len = T.len;

for i= 1: numel(T.q_children)

    Radius.q_childrenR{i}.len0 = T.q_children{i}.len0;
    Radius.q_childrenR{i}.len = T.q_children{i}.len;

end