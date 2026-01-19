function smd_local_matrix(tx, ty, tz, rx, ry, rz)//manually constructs a matrix in zyx order
{
    var cx = cos(rx), sx = sin(rx);
    var cy = cos(ry), sy = sin(ry);
    var cz = cos(rz), sz = sin(rz);

    var m = array_create(16);

    m[0]  = cy * cz;
    m[1]  = cy * sz;
    m[2]  = -sy;
    m[3]  = 0;

    m[4]  = cz*sx*sy - cx*sz;
    m[5]  = cx*cz + sx*sy*sz;
    m[6]  = cy*sx;
    m[7]  = 0;

    m[8]  = cx*cz*sy + sx*sz;
    m[9]  = cx*sy*sz - cz*sx;
    m[10] = cx*cy;
    m[11] = 0;

    m[12] = tx;
    m[13] = ty;
    m[14] = tz;
    m[15] = 1;

    return m;
}
