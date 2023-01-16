export interface IPost{
    id: number;
    noiDung: string;
    created: Date;
    userName: string;
    displayName: string;
    imageUrl: string;
    comments: IComment[];
}

export interface IComment{
    id: number;
    noiDung: string;
    created: Date;
    displayName: string;
    userImageUrl: string;
    postId: number;
}